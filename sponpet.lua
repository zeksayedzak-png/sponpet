-- Pet Merger Script for Mobile
-- Works with one GUI, two-handed operation

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ============ البيانات ============
local PetDatabase = {
    ["Kitsune"] = {
        assetId = 137696262122157, -- ضع AssetID الحقيقي هنا
        weight = 150,
        age = 100
    },
    ["Phoenix"] = {
        assetId = 9876543210,
        weight = 80,
        age = 500
    },
    ["Wolf"] = {
        assetId = 5555555555,
        weight = 60,
        age = 30
    }
}

-- ============ الواجهة للهاتف ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PetMergerMobile"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- إطار رئيسي (للهاتف)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.8, 0, 0.7, 0) -- مناسب للهاتف
MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.Parent = ScreenGui

-- العنوان
local Title = Instance.new("TextLabel")
Title.Text = "🧬 Pet Merger (Mobile)"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

-- قائمة الحيوانات
local PetList = Instance.new("ScrollingFrame")
PetList.Size = UDim2.new(0.9, 0, 0.4, 0)
PetList.Position = UDim2.new(0.05, 0, 0.1, 0)
PetList.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
PetList.Parent = MainFrame

-- زر لكل حيوان
local yOffset = 5
for petName, data in pairs(PetDatabase) do
    local petButton = Instance.new("TextButton")
    petButton.Text = "🐾 " .. petName .. " (W:" .. data.weight .. ", A:" .. data.age .. ")"
    petButton.Size = UDim2.new(0.9, 0, 0, 35)
    petButton.Position = UDim2.new(0.05, 0, 0, yOffset)
    petButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    petButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    petButton.MouseButton1Click:Connect(function()
        SelectedPet = petName
        SelectedData = data
        print("✅ تم اختيار:", petName)
    end)
    
    petButton.Parent = PetList
    yOffset = yOffset + 40
end

-- تعديل الوزن والعمر (للهاتف)
local WeightLabel = Instance.new("TextLabel")
WeightLabel.Text = "الوزن الجديد:"
WeightLabel.Size = UDim2.new(0.4, 0, 0, 30)
WeightLabel.Position = UDim2.new(0.05, 0, 0.55, 0)
WeightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WeightLabel.Parent = MainFrame

local WeightBox = Instance.new("TextBox")
WeightBox.PlaceholderText = "مثال: 120"
WeightBox.Size = UDim2.new(0.4, 0, 0, 30)
WeightBox.Position = UDim2.new(0.5, 0, 0.55, 0)
WeightBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
WeightBox.TextColor3 = Color3.fromRGB(255, 255, 255)
WeightBox.Parent = MainFrame

local AgeLabel = Instance.new("TextLabel")
AgeLabel.Text = "العمر الجديد:"
AgeLabel.Size = UDim2.new(0.4, 0, 0, 30)
AgeLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
AgeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
AgeLabel.Parent = MainFrame

local AgeBox = Instance.new("TextBox")
AgeBox.PlaceholderText = "مثال: 50"
AgeBox.Size = UDim2.new(0.4, 0, 0, 30)
AgeBox.Position = UDim2.new(0.5, 0, 0.65, 0)
AgeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
AgeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AgeBox.Parent = MainFrame

-- ============ عملية الدمج ============
local MergeButton = Instance.new("TextButton")
MergeButton.Text = "🔄 دمج مع Pet الأصلي"
MergeButton.Size = UDim2.new(0.9, 0, 0, 50)
MergeButton.Position = UDim2.new(0.05, 0, 0.8, 0)
MergeButton.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
MergeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MergeButton.Parent = MainFrame

-- متغيرات التحديد
local SelectedPet = nil
local SelectedData = nil
local TargetPet = nil

-- اختيار Pet الأصلي بالنقر
mouse.Button1Down:Connect(function()
    local target = mouse.Target
    if target and target:FindFirstChild("IsPet") then
        TargetPet = target
        print("🎯 تم اختيار Pet الأصلي:", target.Name)
    end
end)

-- تنفيذ الدمج
MergeButton.MouseButton1Click:Connect(function()
    if not SelectedPet then
        print("❌ لم تختر Pet للدمج!")
        return
    end
    
    if not TargetPet then
        print("❌ لم تختر Pet الأصلي!")
        return
    end
    
    -- الحصول على القيم الجديدة
    local newWeight = tonumber(WeightBox.Text) or SelectedData.weight
    local newAge = tonumber(AgeBox.Text) or SelectedData.age
    
    -- عملية الدمج
    local function mergePets()
        -- 1. تغيير المظهر
        TargetPet.MeshId = "rbxassetid://" .. SelectedData.assetId
        
        -- 2. تغيير الإحصائيات
        TargetPet:SetAttribute("Weight", newWeight)
        TargetPet:SetAttribute("Age", newAge)
        TargetPet:SetAttribute("Type", SelectedPet)
        
        -- 3. تغيير الاسم
        TargetPet.Name = SelectedPet .. "_Merged"
        
        -- 4. إضافة تأثيرات (اختياري)
        local glow = Instance.new("ParticleEmitter")
        glow.Texture = "rbxassetid://" .. SelectedData.assetId
        glow.Parent = TargetPet
        
        print("✅ تم دمج " .. SelectedPet .. " في Pet الأصلي!")
        print("📊 الوزن الجديد:", newWeight)
        print("🎂 العمر الجديد:", newAge)
    end
    
    -- التنفيذ مع معالجة الأخطاء
    pcall(mergePets)
end)

-- تعليمات للاستخدام
print("📱 Pet Merger Mobile Loaded!")
print("📝 التعليمات:")
print("1. اختر Pet من القائمة")
print("2. اضبط الوزن والعمر (اختياري)")
print("3. انقر على Pet الأصلي في اللعبة")
print("4. اضغط زر الدمج")
print("5. سيتم استبدال Pet الأصلي بالجديد!")
