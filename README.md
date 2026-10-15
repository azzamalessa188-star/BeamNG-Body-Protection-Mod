# 🛡️ Body Protection Mod for BeamNG.drive
### مود درع البدي (حماية جسم وهيكل السيارة مع استثناء الصدامات)

<div align="center">

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Game: BeamNG.drive](https://img.shields.io/badge/Game-BeamNG.drive-orange.svg)
![Built with AI](https://img.shields.io/badge/Developed%20with-AI%20%F0%9F%A4%96-blue.svg)
![Open Source](https://img.shields.io/badge/Open%20Source-%E2%9D%A4-green.svg)

**[العربية](#-عن-المشروع-باللغة-العربية) • [English](#-about-the-project-english)**

</div>

---

## 🇸🇦 عن المشروع (باللغة العربية)

### 📌 الوصف
مود مجاني ومفتوح المصدر للعبة **BeamNG.drive**، تم تصميمه وبرمجته بالكامل باستخدام **الذكاء الاصطناعي (AI)**.  
يقوم هذا المود بحماية جسم وهيكل السيارة (البدي، الشاصي، الكبينة، الأبواب، السقف، الكبوت، الرفارف) من أي انعفاط أو طعج أو انكسار مهما بلغت قوة وسرعة الاصطدام!  

> **⚠️ الاستثناء الوحيد**:  
> **الصدام الأمامي والصدام الخلفي** مستثنيان من الحماية لتبديد الصدمات بشكل واقعي، بحيث تنعفط وتتكسر وتسقط عند الحوادث لتعطي متعة وواقعية فائقة أثناء اللعب والاصطدام.

---

### ✨ المميزات
* 🟢 **واجهة تحكم بسيطة وسريعة (UI App)**: تحتوي على زرين فقط: **`[ ON ]`** و **`[ OFF ]`** مع إضاءة متوهجة وحالة مباشرة.
* ⌨️ **اختصار كيبورد**: اضغط **`Shift + I`** للتشغيل أو الإيقاف في أي لحظة أثناء القيادة.
* ⭕ **دعم القائمة الدائرية (Radial Menu)**: يمكنك التبديل بضغطة زر واحدة إذا كنت تستخدم يد تحكم (Gamepad) أو دركسون (Wheel).
* 🚗 **توافق شامل**: يعمل تلقائياً مع كافة سيارات اللعبة الأصلية وسيارات المودات بدون الحاجة لتعديل أي ملفات داخل السيارات.
* ⚡ **أداء عالي**: كود محسّن وخفيف جداً، لا يسبب أي هبوط في الفريمات (Zero FPS Drop).

---

### 📥 طريقة التثبيت
1. حمل ملف `BodyProtection.zip` من قسم [Releases](../../releases).
2. انسخ الملف (كما هو بصيغة zip بدون فك ضغط) إلى مجلد المودات الخاص بلعبتك:
   ```
   BeamNG.drive/mods
   ```
3. افتح اللعبة وادخل أي ماب، ثم من القائمة الجانبية اختر **Customize UI Apps** (تعديل الواجهات).
4. اضغط على زر **`+ Add App`** واختر واجهة: **`Body Protection | حماية البدي`**.
5. ضع الواجهة في المكان الذي يعجبك، واضغط **`ON`** واستمتع!

---

### 🔓 مشروع مفتوح المصدر (Open Source)
> 🤖 **ملاحظة للمطورين وهواة التعديل**:  
> تم تطوير هذا المود بالكامل بالذكاء الاصطناعي، والكود **مفتوح المصدر بالكامل بنسبة 100%** تحت رخصة **MIT**.  
> **يحق لأي شخص أخذ الكود، التعديل عليه، تطويره، استخدامه في مشاريع أخرى، أو إعادة نشره كما يشاء وبكل حرية!**

---

<br>

## 🇬🇧 About the Project (English)

### 📌 Description
An open-source mod for **BeamNG.drive**, fully researched and coded using **Artificial Intelligence (AI)**.  
This mod makes your vehicle's body, chassis, cabin, doors, hood, roof, and quarter panels completely indestructible and immune to deformation during high-speed crashes and collisions!

> **⚠️ The Only Exception**:  
> **The Front & Rear Bumpers** remain fully destructible with 100% authentic physics. They can deform, crack, scratch, and detach on impact, providing the perfect balance between action and realistic damage physics.

---

### ✨ Key Features
* 🟢 **Clean 2-Button UI App**: Features only **`[ ON ]`** and **`[ OFF ]`** buttons with glowing visual state indicators.
* ⌨️ **Keyboard Shortcut**: Press **`Shift + I`** anytime while driving to toggle on the fly.
* ⭕ **Radial Menu Integration**: Integrated directly into BeamNG's Quick Access Radial Menu for seamless gamepad and wheel use.
* 🚗 **Universal Compatibility**: Works out of the box with all vanilla cars and modded vehicles.
* ⚡ **Zero Performance Impact**: Ultra-lightweight Lua architecture executing directly through BeamNG's C++ physics core.

---

### 📥 Installation
1. Download `BodyProtection.zip` from [Releases](../../releases).
2. Place the zip file (do not extract) into your BeamNG mods directory:
   ```
   BeamNG.drive/mods
   ```
3. Launch the game, spawn your vehicle, open **Customize UI Apps**, and click **`+ Add App`**.
4. Select **`Body Protection | حماية البدي`**.
5. Place the widget on your screen, click **`ON`**, and enjoy!

---

### 🛠️ Project Structure
```text
BodyProtection/
├── lua/
│   ├── ge/extensions/bodyProtection.lua             # Game Engine Lua (UI, state & input)
│   ├── ge/extensions/core/input/actions/            # Keybind action registration
│   └── vehicle/extensions/auto/bodyProtection.lua   # Vehicle physics auto-extension (2000Hz)
├── mod_info/
│   └── info.json                                   # BeamNG mod metadata
├── scripts/
│   └── bodyProtection/modScript.lua                # Auto-start mounting script
└── ui/
    └── modules/apps/BodyProtection/                # In-Game AngularJS UI App (app.js, app.json, app.png)
```

---

### 📄 License
This project is licensed under the **MIT License** — you are free to inspect, modify, fork, distribute, and enhance the code however you want.

Developed with ❤️ using AI.
