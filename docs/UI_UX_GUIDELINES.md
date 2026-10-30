# UI/UX Design System & Guidelines: StudyMate

## 1. Design Philosophy

The StudyMate visual identity is built on a **modern glassmorphic design system** engineered to feel educational, focused, modern, and trustworthy.

Key Principles:
- **Clarity over Complexity**: Minimal cognitive load for students preparing for examinations.
- **Visual Hierarchy**: Deep layering with semi-transparent frosted-glass containers, subtle neon accents, and crisp typography.
- **Seamless Responsiveness**: Uncompromised usability across mobile smartphones, tablets, and large desktop monitors.
- **Dual-Mode Ergonomics**: Native, high-contrast Dark and Light themes with fluid transitions.

---

## 2. Color Palette & Design Tokens

StudyMate's styling is driven by CSS custom properties defined in `src/main/webapp/assets/css/studymate.css`:

### 2.1 Dark Mode Palette (Default)
```css
[data-theme="dark"] {
    --bg-primary: #0a0e17;           /* Deep midnight void */
    --bg-secondary: #121826;         /* Layered container background */
    --bg-tertiary: #1b2236;          /* Card & interactive surface */
    --text-primary: #f8fafc;         /* Crisp white text */
    --text-secondary: #94a3b8;       /* Slate muted text */
    --text-muted: #64748b;           /* Inactive / hint text */
    --glass-bg: rgba(18, 24, 38, 0.75);      /* Frosted glass backdrop */
    --glass-border: rgba(255, 255, 255, 0.08); /* Subtle specular border */
    --accent-primary: #3b82f6;       /* Electric blue accent */
    --accent-glow: rgba(59, 130, 246, 0.35);  /* Accent blur shadow */
}
```

### 2.2 Light Mode Palette
```css
[data-theme="light"] {
    --bg-primary: #f8fafc;           /* Crisp clean paper canvas */
    --bg-secondary: #ffffff;         /* Elevated card white */
    --bg-tertiary: #f1f5f9;          /* Neutral gray interactive */
    --text-primary: #0f172a;         /* Deep slate contrast text */
    --text-secondary: #475569;       /* Medium slate secondary */
    --text-muted: #94a3b8;           /* Muted borders & icons */
    --glass-bg: rgba(255, 255, 255, 0.85);   /* White frosted glass */
    --glass-border: rgba(15, 23, 42, 0.08);    /* Subtle boundary border */
    --accent-primary: #2563eb;       /* Royal blue primary */
    --accent-glow: rgba(37, 99, 235, 0.20);   /* Soft subtle glow */
}
```

### 2.3 Semantic Status Colors
- **Success**: `#10b981` (Emerald) — Successful actions, verified status.
- **Warning**: `#f59e0b` (Amber) — Pending verification, expiration notices.
- **Danger**: `#ef4444` (Rose) — Errors, delete confirmations, inactive accounts.
- **Info**: `#06b6d4` (Cyan) — Announcement notices, academic tips.

---

## 3. Typography & Hierarchy

- **Font Family**: Modern sans-serif stack (`Inter`, system-ui, -apple-system, `Segoe UI`, Roboto).
- **Scale**:
  - `Display / Hero Title`: `2.75rem` (44px), font-weight `800`, letter-spacing `-0.025em`.
  - `H1 (Page Titles)`: `2.0rem` (32px), font-weight `700`.
  - `H2 (Section Titles)`: `1.5rem` (24px), font-weight `600`.
  - `H3 (Card Headings)`: `1.25rem` (20px), font-weight `600`.
  - `Body Text`: `0.95rem` (15.2px), line-height `1.6`.
  - `Caption / Meta`: `0.80rem` (12.8px), font-weight `500`.

---

## 4. Component Standards

### 4.1 Frosted Glass Cards (`.glass-card`)
- `background: var(--glass-bg);`
- `backdrop-filter: blur(12px);`
- `border: 1px solid var(--glass-border);`
- `border-radius: 1rem;` (16px)
- `box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);`
- Hover state: Subtle elevation `transform: translateY(-4px);` with heightened glow.

### 4.2 Interactive Action Buttons (`.btn-glow`)
- Vibrant gradient: `linear-gradient(135deg, #3b82f6, #1d4ed8)`.
- Border-radius: `0.75rem` (12px).
- Dynamic focus and hover states with CSS box-shadow glows.

### 4.3 Form Inputs (`.form-control`)
- Styled with dark/light background tokens, custom placeholder tints, and a bright blue outline ring on `:focus`.

---

## 5. Accessibility (WCAG 2.1 AA)

- **Color Contrast**: All primary text maintains a minimum contrast ratio of `7:1` against container backgrounds.
- **Focus Rings**: High-visibility outline indicators on all interactive form elements, links, and buttons.
- **Semantic HTML5**: Pages use native `<header>`, `<nav>`, `<main>`, `<section>`, `<aside>`, and `<footer>` elements.
- **Screen Reader Support**: Meaningful `aria-label`, `aria-expanded`, and `role` attributes on icon buttons, modals, and dropdown menus.

