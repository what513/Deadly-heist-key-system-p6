local Config = {
    ServiceId     = 34241, 
    PlatoSecret   = "68dabdde-9d6b-4681-94d0-6b8411c98435", 
    Secret        = "Code", 
    MainScriptURL = "https://pastebin.com/raw/khXn8ejB", -- GANTI DENGAN LINK RAW CHEAT ASLIMU
    KeyFileName   = "Mykey.txt"
}

local host, fGetHwid = "platoboost.com", (gethwid or function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
local hwid = fGetHwid()

local function redeemKey(k)
    local r = request or http_request or syn_request or (http and http.request)
    local body = game:GetService("HttpService"):JSONEncode({identifier = hwid, key = k})
    local s, res = pcall(function() return r({Url = "https://api."..host.."/public/redeem/"..Config.ServiceId, Method = "POST", Body = body, Headers = {["Content-Type"]="application/json"}}) end)
    if s and res.StatusCode == 200 then
        local data = game:GetService("HttpService"):JSONDecode(res.Body)
        if data and data.success and data.data.valid then
            if writefile then writefile(Config.KeyFileName, k) end
            return true
        end
    end
    return false
end

local function StartScript()
    _G[Config.Secret] = true
    loadstring(game:HttpGet(Config.MainScriptURL))()
end

if readfile and isfile(Config.KeyFileName) and redeemKey(readfile(Config.KeyFileName)) then
    task.spawn(StartScript) return
end

local SG = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MF = Instance.new("Frame", SG)
MF.Size, MF.Position, MF.BackgroundColor3, MF.Active, MF.Draggable = UDim2.new(0,300,0,230), UDim2.new(0.5,-150,0.5,-115), Color3.fromRGB(20,20,20), true, true
Instance.new("UICorner", MF)

local function createBtn(txt, pos, col, cb)
    local b = Instance.new("TextButton", MF)
    b.Size, b.Position, b.Text, b.BackgroundColor3, b.TextColor3, b.Font, b.TextSize = UDim2.new(0,260,0,35), pos, txt, col, Color3.new(1,1,1), Enum.Font.GothamBold, 12
    Instance.new("UICorner", b) b.MouseButton1Click:Connect(cb)
end

local T = Instance.new("TextLabel", MF)
T.Size, T.Text, T.TextColor3, T.Font, T.TextSize, T.BackgroundTransparency = UDim2.new(1,0,0,40), "DEADLY HEIST SYSTEM", Color3.fromRGB(0,170,255), Enum.Font.GothamBold, 14, 1

local L = Instance.new("TextLabel", MF)
L.Size, L.Position, L.Text, L.TextColor3, L.Font, L.TextSize, L.BackgroundTransparency = UDim2.new(1,0,0,25), UDim2.new(0,0,0,45), "Status: Menunggu Key...", Color3.new(1,1,1), Enum.Font.Gotham, 11, 1

local box = Instance.new("TextBox", MF)
box.Size, box.Position, box.PlaceholderText, box.Text, box.BackgroundColor3, box.TextColor3 = UDim2.new(0,260,0,35), UDim2.new(0,20,0,80), "Masukkan Key Disini...", "", Color3.fromRGB(30,30,30), Color3.new(1,1,1)
Instance.new("UICorner", box)

createBtn("CHECK KEY", UDim2.new(0,20,0,130), Color3.fromRGB(0,150,255), function()
    if box.Text == "" then L.Text = "Key tidak boleh kosong!" return end
    L.Text = "Memverifikasi..."
    if redeemKey(box.Text) then
        L.Text = "Sukses! Memuat script..." SG:Destroy() task.spawn(StartScript)
    else
        L.Text = "Key Salah atau Expired!"
    end
end)

createBtn("GET KEY (COPY LINK)", UDim2.new(0,20,0,175), Color3.fromRGB(230,125,0), function()
    if setclipboard then
        -- Pembetulan String URL Gabungan (Ditambahkan tanda "/" pemisah domain yang benar)
        local directUrl = "https://platoboost.com" .. tostring(Config.ServiceId) .. "?id=" .. tostring(hwid)
        setclipboard(directUrl) 
        L.Text = "Link Iklan Berhasil Disalin!"
    else
        L.Text = "Executor tidak mendukung clipboard!"
    end
end)
