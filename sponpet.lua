-- Pet Merger Mobile - إصدار مصحح
-- كل الـPets عندهم نفس AssetsID

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ============ الإعدادات الثابتة ============
local UNIVERSAL_ASSET_ID = 137696262122157 -- نفس الرقم من السكربت الأصلي!

local PET_NAMES = {
    "Rhino",
    "T-Rex",
    "Phoenix", 
    "Kitsune",
    "Headless Horseman",
    "Capybara",
    "Dragon",
    "Wolf"
}

-- ============ واجهة الهاتف المصغرة ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobilePetMerger"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- إطار صغير (نصف الشاشة)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.Active = true
MainFrame.Draggable = true -- يمكن تحريكه ✨
MainFrame.Parent = ScreenGui

-- العنوان
local Title = Instance.new("TextLabel")
Title.Text = "🔄 دمج Pet"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

-- ============ الخانات الثلاث ============
local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
InputFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
InputFrame.BackgroundTransparency = 1
InputFrame.Parent = MainFrame

-- 1. اسم Pet
local NameLabel = Instance.new("TextLabel")
NameLabel.Text = "اسم Pet:"
NameLabel.Size = UDim2.new(1, 0, 0, 25)
NameLabel.Position = UDim2.new(0, 0, 0, 0)
NameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
NameLabel.Parent = InputFrame

local NameBox = Instance.new("TextBox")
NameBox.PlaceholderText = "مثال: Dragon"
NameBox.Size = UDim2.new(1, 0, 0, 35)
NameBox.Position = UDim2.new(0, 0, 0, 25)
NameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NameBox.Parent = InputFrame

-- زر اختيار من قائمة
local NameListButton = Instance.new("TextButton")
NameListButton.Text = "📋 اختر من القائمة"
NameListButton.Size = UDim2.new(1, 0, 0, 30)
NameListButton.Position = UDim2.new(0, 0, 0, 65)
NameListButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
NameListButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NameListButton.Parent = InputFrame

-- 2. الوزن
local WeightLabel = Instance.new("TextLabel")
WeightLabel.Text = "الوزن (KG):"
WeightLabel.Size = UDim2.new(1, 0, 0, 25)
WeightLabel.Position = UDim2.new(0, 0, 0, 105)
WeightLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
WeightLabel.Parent = InputFrame

local WeightBox = Instance.new("TextBox")
WeightBox.PlaceholderText = "مثال: 2.89"
WeightBox.Size = UDim2.new(1, 0, 0, 35)
WeightBox.Position = UDim2.new(0, 0, 0, 130)
WeightBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
WeightBox.TextColor3 = Color3.fromRGB(255, 255, 255)
WeightBox.Parent = InputFrame

-- 3. العمر
local AgeLabel = Instance.new("TextLabel")
AgeLabel.Text = "العمر:"
AgeLabel.Size = UDim2.new(1, 0, 0, 25)
AgeLabel.Position = UDim2.new(0, 0, 0, 175)
AgeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
AgeLabel.Parent = InputFrame

local AgeBox = Instance.new("TextBox")
AgeBox.PlaceholderText = "مثال: 12"
AgeBox.Size = UDim2.new(1, 0, 0, 35)
AgeBox.Position = UDim2.new(0, 0, 0, 200)
AgeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
AgeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AgeBox.Parent = InputFrame

-- ============ أزرار التحكم ============
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(0.9, 0, 0, 80)
ControlFrame.Position = UDim2.new(0.05, 0, 0.85, 0)
ControlFrame.BackgroundTransparency = 1
ControlFrame.Parent = MainFrame

-- زر تحديد Pet الأصلي
local SelectButton = Instance.new("TextButton")
SelectButton.Text = "🎯 انقر على Pet الأصلي"
SelectButton.Size = UDim2.new(1, 0, 0, 35)
SelectButton.Position = UDim2.new(0, 0, 0, 0)
SelectButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
SelectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectButton.Parent = ControlFrame

-- زر الدمج
local MergeButton = Instance.new("TextButton")
MergeButton.Text = "🔄 دمج الآن"
MergeButton.Size = UDim2.new(1, 0, 0, 35)
MergeButton.Position = UDim2.new(0, 0, 0, 40)
MergeButton.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
MergeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MergeButton.Parent = ControlFrame

-- ============ المتغيرات ============
local SelectedPet = nil -- Pet الأصلي المحدد
local TargetName = ""   -- الاسم الجديد
local TargetWeight = 0  -- الوزن الجديد
local TargetAge = 0     -- العمر الجديد

-- ============ قائمة الأسماء ============
NameListButton.MouseButton1Click:Connect(function()
    local SelectionFrame = Instance.new("Frame")
    SelectionFrame.Size = UDim2.new(0.8, 0, 0.6, 0)
    SelectionFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
    SelectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SelectionFrame.Parent = MainFrame
    
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(0.9, 0, 0.8, 0)
    Scroll.Position = UDim2.new(0.05, 0, 0.1, 0)
    Scroll.BackgroundTransparency = 1
    Scroll.Parent = SelectionFrame
    
    local yPos = 5
    for _, petName in pairs(PET_NAMES) do
        local btn = Instance.new("TextButton")
        btn.Text = "🐾 " .. petName
        btn.Size = UDim2.new(0.9, 0, 0, 30)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        btn.MouseButton1Click:Connect(function()
            NameBox.Text = petName
            SelectionFrame:Destroy()
        end)
        
        btn.Parent = Scroll
        yPos = yPos + 35
    end
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "❌ إغلاق"
    CloseBtn.Size = UDim2.new(0.9, 0, 0, 25)
    CloseBtn.Position = UDim2.new(0.05, 0, 0.9, 0)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    CloseBtn.MouseButton1Click:Connect(function()
        SelectionFrame:Destroy()
    end)
    
    CloseBtn.Parent = SelectionFrame
end)

-- ============ تحديد Pet الأصلي ============
local mouse = LocalPlayer:GetMouse()

SelectButton.MouseButton1Click:Connect(function()
    SelectButton.Text = "🎯 الآن انقر على Pet..."
    SelectButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
    
    local connection
    connection = mouse.Button1Down:Connect(function()
        local target = mouse.Target
        if target and target.Parent and target.Parent:IsA("Tool") then
            if target.Parent:GetAttribute("ItemType") == "Pet" then
                SelectedPet = target.Parent
                SelectButton.Text = "✅ تم اختيار: " .. SelectedPet.Name
                SelectButton.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
                connection:Disconnect()
            end
        end
    end)
    
    task.wait(5)
    if connection then
        connection:Disconnect()
        SelectButton.Text = "🎯 انقر على Pet الأصلي"
        SelectButton.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
    end
end)

-- ============ دالة الدمج الرئيسية ============
local function mergePetIntoTarget()
    if not SelectedPet then
        warn("❌ لم تختر Pet أصلي!")
        return
    end
    
    -- الحصول على القيم
    TargetName = NameBox.Text
    TargetWeight = tonumber(WeightBox.Text) or 1.0
    TargetAge = tonumber(AgeBox.Text) or 1
    
    if TargetName == "" then
        warn("❌ أدخل اسم Pet!")
        return
    end
    
    -- حفظ الـUUID الأصلي
    local originalUUID = SelectedPet:GetAttribute("PET_UUID")
    local originalOwner = SelectedPet:GetAttribute("OWNER")
    
    -- تغيير الاسم مع الوزن والعمر
    local newName = TargetName .. " [" .. string.format("%.2f", TargetWeight) .. " KG] [Age " .. TargetAge .. "]"
    
    -- تغيير الخصائظ
    SelectedPet.Name = newName
    SelectedPet:SetAttribute("Weight", TargetWeight)
    SelectedPet:SetAttribute("Age", TargetAge)
    SelectedPet:SetAttribute("PetType", TargetName)
    
    -- الحفاظ على الهوية الأصلية
    SelectedPet:SetAttribute("PET_UUID", originalUUID)
    SelectedPet:SetAttribute("OWNER", originalOwner)
    
    -- إشعار النجاح
    MergeButton.Text = "✅ تم الدمج!"
    MergeButton.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
    
    print("🎉 تم دمج Pet بنجاح!")
    print("🔤 الاسم الجديد:", newName)
    print("⚖️ الوزن:", TargetWeight)
    print("🎂 العمر:", TargetAge)
    print("🔐 UUID محفوظ:", originalUUID)
    
    task.wait(2)
    MergeButton.Text = "🔄 دمج الآن"
    MergeButton.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
end

MergeButton.MouseButton1Click:Connect(mergePetIntoTarget)

-- ============ تهيئة ============
print("📱 Pet Merger Mobile Loaded!")
print("🎯 التعليمات:")
print("1. أدخل اسم Pet الجديد")
print("2. أدخل الوزن والعمر")
print("3. انقر على Pet الأصلي")
print("4. اضغط دمج الآن")
print("📱 الواجهة قابلة للسحب!")
