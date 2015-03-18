window.fakeEvent = function (type) {
    return $.extend($.Event(type), {
        preventDefault: jasmine.createSpy('preventDefault')
    });
};
