import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class ZsvirtGirlView extends WatchUi.WatchFace {
    private var _portrait;
    private var _width as Number = 0;
    private var _height as Number = 0;
    private var _centerX as Number = 0;
    private var _curved as Boolean = false;
    private var _unit as Number = 1;
    private var _gap as Number = 0;
    private var _smallHeight as Number = 0;
    private var _periodWidth as Number = 0;
    private var _timeFont = Graphics.FONT_NUMBER_MEDIUM;
    private var _timeX as Number = 0;
    private var _timeY as Number = 0;
    private var _periodX as Number = 0;
    private var _periodY as Number = 0;
    private var _timeLayoutDirty as Boolean = true;
    private var _metricsY as Number = 0;
    private var _batteryX as Number = 0;
    private var _batteryTextX as Number = 0;
    private var _dateX as Number = 0;
    private var _sleeping as Boolean = false;
    private var _aodFont = Graphics.FONT_NUMBER_MILD;
    private var _aodUpperY as Number = 0;
    private var _aodLowerY as Number = 0;
    private var _aodPeriodOffset as Number = 0;
    private var _hour as Number = -1;
    private var _minute as Number = -1;
    private var _is24Hour as Boolean = true;
    private var _time as String = "";
    private var _period as String = "";
    private var _battery as Number = -1;
    private var _batteryFill as Number = 0;
    private var _batteryText as String = "";
    private var _dateKey as Number = -1;
    private var _dateText as String = "";

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Graphics.Dc) as Void {
        _portrait = WatchUi.loadResource(Rez.Drawables.GirlPortrait);
        _width = dc.getWidth();
        _height = dc.getHeight();
        _centerX = _width / 2;
        // The matrix has circles, a 215x180 clipped circle, and a 205x148 rectangle.
        _curved = _width == _height || (_width == 215 && _height == 180);
        _unit = _width >= 360 ? 2 : 1;
        _gap = 3 * _unit;
        _smallHeight = dc.getFontHeight(Graphics.FONT_XTINY);
        _periodWidth = larger(dc.getTextWidthInPixels("AM", Graphics.FONT_XTINY),
            dc.getTextWidthInPixels("PM", Graphics.FONT_XTINY));

        // Reserve the full date and percentage even when today's values are narrower.
        var digit = widestDigit(dc, Graphics.FONT_XTINY);
        var dateWidth = 4 * digit + dc.getTextWidthInPixels("/", Graphics.FONT_XTINY);
        var batteryWidth = 3 * digit + dc.getTextWidthInPixels("%", Graphics.FONT_XTINY);
        var dateGap = _height * 18 / 280;
        var rowWidth = dateWidth + dateGap + 21 * _unit + batteryWidth;
        var rowHeight = larger(_smallHeight, 8 * _unit);
        _metricsY = _height * 248 / 280;
        var bottom = _height - 2 * _unit;
        if (_curved) {
            var radius = _width / 2;
            var halfWidth = (rowWidth + 1) / 2 + 2 * _unit;
            if (halfWidth >= radius) {
                System.println("Girl metrics exceed display width");
                throw new Lang.Exception();
            }
            bottom = smaller(bottom, _height / 2 +
                Math.sqrt(radius * radius - halfWidth * halfWidth).toNumber());
        }
        _metricsY = smaller(_metricsY, bottom - (rowHeight + 1) / 2);
        _dateX = (_width - rowWidth) / 2;
        _batteryX = _dateX + dateWidth + dateGap;
        _batteryTextX = _batteryX + 21 * _unit;

        if (!layoutTime(dc, Graphics.FONT_NUMBER_MEDIUM, rowHeight) &&
                !layoutTime(dc, Graphics.FONT_NUMBER_MILD, rowHeight) &&
                !layoutTime(dc, Graphics.FONT_LARGE, rowHeight) &&
                !layoutTime(dc, Graphics.FONT_MEDIUM, rowHeight) &&
                !layoutTime(dc, Graphics.FONT_SMALL, rowHeight) &&
                !layoutTime(dc, Graphics.FONT_XTINY, rowHeight)) {
            System.println("Girl time does not fit below portrait");
            throw new Lang.Exception();
        }
        if (DeviceProfile.AMOLED &&
                !layoutAod(dc, Graphics.FONT_NUMBER_MILD) &&
                !layoutAod(dc, Graphics.FONT_MEDIUM) &&
                !layoutAod(dc, Graphics.FONT_SMALL) &&
                !layoutAod(dc, Graphics.FONT_XTINY)) {
            System.println("Girl AOD exceeds display bounds");
            throw new Lang.Exception();
        }
        _timeLayoutDirty = true;
    }

    private function larger(a as Number, b as Number) as Number {
        return a > b ? a : b;
    }

    private function smaller(a as Number, b as Number) as Number {
        return a < b ? a : b;
    }

    private function widestDigit(dc as Graphics.Dc, font) as Number {
        var width = dc.getTextWidthInPixels("0", font);
        width = larger(width, dc.getTextWidthInPixels("1", font));
        width = larger(width, dc.getTextWidthInPixels("2", font));
        width = larger(width, dc.getTextWidthInPixels("3", font));
        width = larger(width, dc.getTextWidthInPixels("4", font));
        width = larger(width, dc.getTextWidthInPixels("5", font));
        width = larger(width, dc.getTextWidthInPixels("6", font));
        width = larger(width, dc.getTextWidthInPixels("7", font));
        width = larger(width, dc.getTextWidthInPixels("8", font));
        return larger(width, dc.getTextWidthInPixels("9", font));
    }

    private function timeWidth(dc as Graphics.Dc, font) as Number {
        return 4 * widestDigit(dc, font) + dc.getTextWidthInPixels(":", font);
    }

    private function availableWidth(y as Number, height as Number) as Number {
        var halfHeight = (height + 1) / 2;
        if (y - halfHeight < 0 || y + halfHeight >= _height) {
            return 0;
        }
        if (!_curved) {
            return _width - 4 * _unit;
        }
        var offset = larger(_height / 2 - y, y - _height / 2) + halfHeight;
        var radius = _width / 2;
        if (offset >= radius) {
            return 0;
        }
        return 2 * Math.sqrt(radius * radius - offset * offset).toNumber() - 4 * _unit;
    }

    private function layoutTime(dc as Graphics.Dc, font, metricsHeight as Number) as Boolean {
        var fontHeight = dc.getFontHeight(font);
        var rowHeight = larger(fontHeight, _smallHeight);
        // Resources finish fading at round(height * 172 / 280), then retain a white strip.
        var top = (_height * 172 + 140) / 280;
        var bottom = _metricsY - (metricsHeight + 1) / 2 - _gap;
        if (rowHeight > bottom - top) {
            return false;
        }
        var y = smaller(_height * 207 / 280, bottom - (rowHeight + 1) / 2);
        y = larger(y, top + (rowHeight + 1) / 2);
        if (timeWidth(dc, font) + 2 * _gap + _periodWidth > availableWidth(y, rowHeight)) {
            return false;
        }
        _timeFont = font;
        _timeY = y;
        _periodY = y + smaller(_height * 8 / 280, (rowHeight - _smallHeight) / 2);
        return true;
    }

    private function layoutAod(dc as Graphics.Dc, font) as Boolean {
        var fontHeight = dc.getFontHeight(font);
        var width = timeWidth(dc, font);
        // 7% of the bounding square is below 10% of a circular display, with margin.
        var area = (width + 2) * (fontHeight + 2) + (_periodWidth + 2) * (_smallHeight + 2);
        var blockHeight = fontHeight + _gap + _smallHeight;
        if (area >= _width * _height * 7 / 100 || blockHeight + 4 * _unit >= _height / 2) {
            return false;
        }
        var upper = _height / 4 - (_smallHeight + _gap + 1) / 2;
        var lower = _height * 3 / 4 - (_smallHeight + _gap + 1) / 2;
        var periodOffset = (fontHeight + _smallHeight + 1) / 2 + _gap;
        if (width > availableWidth(upper, fontHeight) || width > availableWidth(lower, fontHeight) ||
                _periodWidth > availableWidth(upper + periodOffset, _smallHeight) ||
                _periodWidth > availableWidth(lower + periodOffset, _smallHeight)) {
            return false;
        }
        _aodFont = font;
        _aodUpperY = upper;
        _aodLowerY = lower;
        _aodPeriodOffset = periodOffset;
        return true;
    }

    function onEnterSleep() as Void {
        _sleeping = true;
        WatchUi.requestUpdate();
    }

    function onExitSleep() as Void {
        _sleeping = false;
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var clock = System.getClockTime();
        var is24Hour = System.getDeviceSettings().is24Hour;
        if (clock.hour != _hour || clock.min != _minute || is24Hour != _is24Hour) {
            _hour = clock.hour;
            _minute = clock.min;
            _is24Hour = is24Hour;
            _time = FaceTime.format(_hour, _minute, _is24Hour);
            _period = FaceTime.period(_hour, _is24Hour);
            _timeLayoutDirty = true;
        }
        if (DeviceProfile.AMOLED && _sleeping) {
            dc.setColor(0x555555, Graphics.COLOR_BLACK);
            dc.clear();
            var y = (_minute % 2 == 0) ? _aodUpperY : _aodLowerY;
            dc.setColor(0x555555, Graphics.COLOR_TRANSPARENT);
            dc.drawText(_centerX, y, _aodFont, _time,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            if (!_is24Hour) {
                dc.drawText(_centerX, y + _aodPeriodOffset, Graphics.FONT_XTINY, _period,
                    Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            }
            return;
        }
        if (_timeLayoutDirty) {
            var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
            var month = date.month as Number;
            var dateKey = date.year * 10000 + month * 100 + date.day;
            if (dateKey != _dateKey) {
                _dateKey = dateKey;
                _dateText = month.format("%02d") + "/" + date.day.format("%02d");
            }
            var timeWidth = dc.getTextWidthInPixels(_time, _timeFont);
            var periodWidth = _is24Hour ? 0 : dc.getTextWidthInPixels(_period, Graphics.FONT_XTINY) + 2 * _gap;
            _timeX = _centerX - periodWidth / 2;
            _periodX = _timeX + timeWidth / 2 + 2 * _gap;
            _timeLayoutDirty = false;
        }
        var battery = System.getSystemStats().battery.toNumber();
        if (battery != _battery) {
            _battery = battery;
            _batteryFill = battery * 10 * _unit / 100;
            _batteryText = battery.toString() + "%";
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        dc.drawBitmap(0, 0, _portrait);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(_timeX, _timeY, _timeFont, _time,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        if (!_is24Hour) {
            dc.drawText(_periodX, _periodY, Graphics.FONT_XTINY, _period,
                Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        }
        dc.drawRectangle(_batteryX, _metricsY - 4 * _unit, 15 * _unit, 8 * _unit);
        dc.fillRectangle(_batteryX + 15 * _unit, _metricsY - 2 * _unit, 2 * _unit, 4 * _unit);
        if (_batteryFill > 0) {
            dc.fillRectangle(_batteryX + 2 * _unit, _metricsY - 2 * _unit, _batteryFill, 4 * _unit);
        }
        dc.drawText(_batteryTextX, _metricsY, Graphics.FONT_XTINY, _batteryText,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(_dateX, _metricsY, Graphics.FONT_XTINY, _dateText,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}
