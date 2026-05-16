# MathLock — פרסום לGitHub (הרץ פעם אחת)
# ============================================

Write-Host ""
Write-Host "🔐 MathLock — פרסום ל-GitHub" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# שלב 1: GitHub Login
Write-Host "שלב 1: כניסה ל-GitHub..." -ForegroundColor Yellow
gh auth login --hostname github.com --web --git-protocol https
if ($LASTEXITCODE -ne 0) { Write-Host "שגיאה בכניסה לGitHub" -ForegroundColor Red; exit 1 }

# שלב 2: git init
Write-Host ""
Write-Host "שלב 2: אתחול git..." -ForegroundColor Yellow
Set-Location $PSScriptRoot
git init
git add .
git commit -m "feat: MathLock initial release — multiplication lock screen"

# שלב 3: יצירת repo ב-GitHub
Write-Host ""
Write-Host "שלב 3: יוצר repo ב-GitHub..." -ForegroundColor Yellow
gh repo create mathlock --public --source=. --remote=origin --push

# שלב 4: הפעל GitHub Pages
Write-Host ""
Write-Host "שלב 4: מפעיל GitHub Pages..." -ForegroundColor Yellow
$repoName = gh repo view --json nameWithOwner -q ".nameWithOwner"
gh api "repos/$repoName/pages" -X POST -f source='{"branch":"gh-pages","path":"/"}' 2>$null
gh api "repos/$repoName" -X PATCH -f has_pages=true 2>$null

# שלב 5: הצג את הלינקים
Write-Host ""
Write-Host "✅ הכל מוכן!" -ForegroundColor Green
Write-Host "============" -ForegroundColor Green
Write-Host ""
Write-Host "GitHub Actions בונה את האפליקציה עכשיו (~5 דקות)..." -ForegroundColor White
Write-Host ""
$username = gh api user -q ".login"
Write-Host "📲 לינק לשיתוף בוואטסאפ:" -ForegroundColor Cyan
Write-Host "   https://$username.github.io/mathlock" -ForegroundColor White
Write-Host ""
Write-Host "⚙️  לינק ל-Actions (לראות את הבנייה):" -ForegroundColor Cyan
Write-Host "   https://github.com/$repoName/actions" -ForegroundColor White
Write-Host ""
Write-Host "אחרי ~5 דקות הלינק יהיה פעיל עם כפתור הורדה." -ForegroundColor Yellow
Write-Host ""
