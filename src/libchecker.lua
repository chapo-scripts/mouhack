local ffi = require("ffi")
ffi.cdef [[
    int MessageBoxA(
        void* hWnd,
        const char* lpText,
        const char* lpCaption,
        unsigned int uType
    );
]]

local modules = {
    { name = "mimgui",           path = "mimgui",         url = "https://www.blast.hk/threads/66959/" },
    { name = "Carb JSON Config", path = "carbJsonConfig", url = "https://www.blast.hk/threads/214849/" }
}

for _, lib in ipairs(modules) do
    local status = pcall(require, lib.path)
    if (not status) then
        local errorText = ("Библиотека \"%s\" (%s) не найдена."):format(lib.path, lib.name)
        if (ffi.C.MessageBoxA(ffi.cast('void*', 0), errorText .. "\nОткрыть страницу загрузки?", "title", 1) == 6) then
            os.execute(("explorer \"%s\""):format(lib.url))
        end
        return error(errorText)
    end
end
