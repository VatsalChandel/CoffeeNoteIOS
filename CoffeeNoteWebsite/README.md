# CoffeeNote Website

Official website for the CoffeeNote iOS app - Track your coffee shop adventures.

## 🌐 Website Structure

```
CoffeeNoteWebsite/
├── index.html          # Main landing page
├── privacy.html        # Privacy Policy (required for App Store)
├── terms.html          # Terms of Service
├── assets/
│   ├── images/
│   │   ├── screenshots/     # App screenshots
│   │   ├── features/        # Feature-specific images
│   │   └── hero-mockup.png  # Main hero image
│   ├── videos/              # Demo videos (optional)
│   └── css/                 # Custom CSS (if needed)
└── README.md
```

## 📸 Adding Screenshots

The website has placeholders for screenshots that you need to replace with actual app screenshots.

### Screenshots Needed

**Essential Screenshots (6):**
1. **visits-list.png** - Main visits list view
2. **add-visit.png** - Add visit form
3. **map-view.png** - Map with pins (Premium)
4. **wishlist.png** - Wishlist view (Premium)
5. **profile.png** - Profile & statistics
6. **visit-detail.png** - Visit detail view

**Optional (2-3):**
7. **paywall.png** - Premium upgrade screen
8. **empty-state.png** - Clean first-time experience
9. **search.png** - Search/filter functionality

### How to Take Screenshots

**Option 1: iPhone Simulator (Recommended)**
1. Run CoffeeNote in Xcode iOS Simulator
2. Choose iPhone 15 Pro or iPhone 14 Pro
3. Navigate to the screen you want to capture
4. Cmd+S to save screenshot
5. Files saved to Desktop

**Option 2: Physical iPhone**
1. Run CoffeeNote on your iPhone
2. Navigate to the screen
3. Press Volume Up + Side Button simultaneously
4. Screenshot saved to Photos app
5. AirDrop to your Mac

**Option 3: Screen Recording**
1. Use QuickTime on Mac → File → New Movie Recording
2. Select your iPhone as source
3. Record app navigation
4. Extract frames using video editing software

### Recommended Screenshot Settings
- **Device**: iPhone 15 Pro (1179 × 2556)
- **Orientation**: Portrait
- **Mode**: Both light and dark mode
- **Data**: Use realistic, not test data
- **Status Bar**: Full signal, good battery level

### Adding Screenshots to Website

1. **Save screenshots to the correct folder:**
   ```
   assets/images/screenshots/
   ├── visits-list.png
   ├── add-visit.png
   ├── map-view.png
   ├── wishlist.png
   ├── profile.png
   └── visit-detail.png
   ```

2. **Edit index.html and replace placeholders:**

   Find these sections and update the `src` attributes:

   **Hero Section (Line ~300):**
   ```html
   <!-- Currently shows placeholder, replace with: -->
   <img src="assets/images/hero-mockup.png" alt="CoffeeNote App" class="w-full h-full object-cover rounded-2xl">
   ```

   **Features Section:**
   ```html
   <!-- Feature 1 - Track Visits -->
   <img src="assets/images/features/track-visits.png" alt="Track Visits" class="w-full rounded-lg shadow-lg">

   <!-- Feature 2 - Map View -->
   <img src="assets/images/features/map-feature.png" alt="Map View" class="w-full rounded-lg shadow-lg">

   <!-- Feature 3 - Wishlist -->
   <img src="assets/images/features/wishlist-feature.png" alt="Wishlist" class="w-full rounded-lg shadow-lg">

   <!-- Feature 4 - Statistics -->
   <img src="assets/images/features/statistics.png" alt="Statistics" class="w-full rounded-lg shadow-lg">
   ```

   **Screenshots Gallery (Line ~600):**
   ```html
   <img src="assets/images/screenshots/visits-list.png" alt="Visits List">
   <img src="assets/images/screenshots/add-visit.png" alt="Add Visit">
   <img src="assets/images/screenshots/map-view.png" alt="Map View">
   <img src="assets/images/screenshots/wishlist.png" alt="Wishlist">
   <img src="assets/images/screenshots/profile.png" alt="Profile">
   <img src="assets/images/screenshots/visit-detail.png" alt="Visit Detail">
   ```

## 📱 Creating Professional iPhone Mockups

Use these free tools to add iPhone frames to your screenshots:

### Option 1: Shots.so (Recommended)
1. Go to https://shots.so
2. Upload your screenshot
3. Choose iPhone 15 Pro frame
4. Customize background color (coffee theme)
5. Download PNG

### Option 2: Screely
1. Go to https://www.screely.com
2. Upload screenshot
3. Add browser mockup or phone frame
4. Customize gradient background
5. Download

### Option 3: MockUPhone
1. Go to https://mockuphone.com
2. Upload screenshot
3. Select iPhone model
4. Download mockup

### Option 4: Manual Photoshop/Figma
- Download iPhone 15 Pro mockup template
- Place screenshot inside device frame
- Export as PNG

## 🎬 Adding Demo Videos (Optional)

### Creating a Demo Video

**What to Record:**
1. Quick navigation through tabs (5-10 seconds)
2. Adding a visit (10 seconds)
3. Viewing on map (5 seconds)
4. Total: 20-30 seconds

**Tools:**
- **QuickTime**: Record iPhone screen
- **Xcode Simulator**: Easier to control
- **Screen Recording**: iPhone built-in (Control Center)

**Video Settings:**
- Format: MP4 (H.264)
- Resolution: 1080p or 1179×2556
- Max size: 5MB for web
- Loop: Yes (for hero section)

### Adding Video to Website

1. Save video to `assets/videos/demo.mp4`

2. Add to hero section (replace phone mockup):
   ```html
   <video autoplay loop muted playsinline class="w-full h-full object-cover rounded-2xl">
       <source src="assets/videos/demo.mp4" type="video/mp4">
   </video>
   ```

3. Or embed YouTube video in a dedicated section:
   ```html
   <iframe width="560" height="315" src="https://www.youtube.com/embed/YOUR_VIDEO_ID"
           frameborder="0" allow="autoplay; encrypted-media" allowfullscreen>
   </iframe>
   ```

## 🚀 Deployment

### Option 1: GitHub Pages (Free, Recommended)

1. **Create GitHub repository**
   ```bash
   cd CoffeeNoteWebsite
   git init
   git add .
   git commit -m "Initial website commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/coffeenote-website.git
   git push -u origin main
   ```

2. **Enable GitHub Pages**
   - Go to repository Settings
   - Pages section
   - Source: Deploy from main branch
   - Root directory: / (root)
   - Save

3. **Your website will be live at:**
   `https://YOUR_USERNAME.github.io/coffeenote-website/`

### Option 2: Netlify (Free, Easy)

1. **Drag & drop deployment:**
   - Go to https://netlify.com
   - Sign up/login
   - Drag the CoffeeNoteWebsite folder into Netlify
   - Done! Auto-deployed with custom domain support

2. **Custom domain (optional):**
   - Buy domain (e.g., coffeenote.app)
   - Point DNS to Netlify
   - Add domain in Netlify settings

### Option 3: Vercel (Free)

1. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```

2. Deploy:
   ```bash
   cd CoffeeNoteWebsite
   vercel
   ```

3. Follow prompts, website deployed instantly

### Option 4: Firebase Hosting (Free)

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

2. Initialize:
   ```bash
   cd CoffeeNoteWebsite
   firebase init hosting
   ```

3. Deploy:
   ```bash
   firebase deploy
   ```

## ✏️ Customization

### Changing Colors

The website uses Tailwind CSS with custom coffee theme colors defined in `index.html`:

```javascript
colors: {
    'coffee-brown': '#734F38',
    'coffee-gold': '#D9A64A',
    'coffee-cream': '#F5E6D3',
    'coffee-dark': '#2C1810',
}
```

To change colors, edit these values in the `<script>` tag.

### Updating Content

- **Hero headline**: Line 250
- **Features**: Lines 400-650
- **Pricing**: Lines 700-850
- **FAQ**: Lines 900-1200
- **Footer email**: Line 1400

### Adding Google Analytics (Optional)

Add before closing `</head>` tag:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-XXXXXXXXXX');
</script>
```

## 📧 Updating Contact Email

Replace `support@coffeenote.app` with your actual email in:
- `index.html` (footer and CTA sections)
- `privacy.html` (contact section)
- `terms.html` (contact section)

## ✅ Pre-Launch Checklist

Before going live:

- [ ] Replace all placeholder screenshots with actual app images
- [ ] Update contact email addresses
- [ ] Test all navigation links
- [ ] Test mobile responsiveness
- [ ] Check Privacy Policy and Terms of Service
- [ ] Add real App Store link (when available)
- [ ] Test forms and buttons
- [ ] Verify FAQ answers are accurate
- [ ] Add Google Analytics (optional)
- [ ] Test on multiple browsers (Safari, Chrome, Firefox)
- [ ] Test on mobile devices (iPhone, Android)

## 📱 Using for App Store Submission

When submitting to the App Store, Apple requires:

1. **Privacy Policy URL**: `https://your-domain.com/privacy.html`
2. **Terms of Service URL**: `https://your-domain.com/terms.html`
3. **Marketing URL** (optional): `https://your-domain.com`

Make sure these pages are live and accessible before App Store submission.

## 🎨 Design Credits

- **Framework**: Tailwind CSS
- **Icons**: Heroicons (via Tailwind)
- **Fonts**: Inter (Google Fonts)
- **Color Palette**: Custom coffee theme

## 🛠️ Tech Stack

- HTML5
- Tailwind CSS (via CDN)
- Vanilla JavaScript
- No build process required
- Mobile-first responsive design

## 📄 License

This website template is part of the CoffeeNote project.

## 💡 Tips

1. **Keep it simple**: Don't over-complicate the design
2. **Use real data**: Screenshots should show realistic coffee shop visits
3. **Mobile first**: Most visitors will view on mobile
4. **Fast loading**: Optimize images (use WebP format, compress to <200KB each)
5. **Test everything**: Click every link, test on multiple devices

## 🔗 Useful Links

- **Tailwind CSS Docs**: https://tailwindcss.com/docs
- **Heroicons**: https://heroicons.com
- **Shots.so (Mockups)**: https://shots.so
- **TinyPNG (Image Compression)**: https://tinypng.com
- **GitHub Pages Guide**: https://pages.github.com
- **Netlify Docs**: https://docs.netlify.com

---

**Made with ☕ and Tailwind CSS**
