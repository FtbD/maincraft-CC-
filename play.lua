local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

if not speaker then
    print("Ошибка: динамик (Speaker) не найден!")
    return
end

local tracks = {}
local dirs = {"", "disk", "disk2", "disk3"}

for _, dir in ipairs(dirs) do
    if fs.exists(dir) and fs.isDir(dir) then
        for _, file in ipairs(fs.list(dir)) do
            if string.find(file, "%.dfpwm$") then
                local fullPath = (dir == "") and file or (dir .. "/" .. file)
                table.insert(tracks, fullPath)
            end
        end
    end
end

if #tracks == 0 then
    print("Файлы .dfpwm не найдены! Сначала скачайте песни.")
    return
end

term.clear()
term.setCursorPos(1, 1)
print("=== Выберите трек ===")
for i, track in ipairs(tracks) do
    print(i .. ". " .. track)
end
print("=====================")
write("Введите номер: ")

local choice = tonumber(read())

if not choice or not tracks[choice] then
    print("Неверный номер трека!")
    return
end

local selectedTrack = tracks[choice]
local decoder = dfpwm.make_decoder()

print("Играет: " .. selectedTrack)
print("(Нажмите Ctrl + T для остановки)")

for chunk in io.lines(selectedTrack, 16 * 1024) do
    local buffer = decoder(chunk)
    while not speaker.playAudio(buffer) do
        os.pullEvent("speaker_audio_empty")
    end
end

print("Воспроизведение завершено.")
