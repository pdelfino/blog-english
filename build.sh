#!/bin/sh
emacs -Q --batch --script build-site.el

# --- Clean URLs: turn foo.html into foo/index.html ---

cd public

# 1. Rewrite internal href="...html" → href=".../"
#    Only touches relative links (skips anything with ":" or "#" at start).
find . -name '*.html' \
  -exec perl -i -pe 's{href="([^":#]+?)\.html"}{href="$1/"}g' {} +

# 2. Files inside subdirs (posts/, lists/) move one level deeper when
#    renamed to dir/index.html, so bare sibling links like href="bar/"
#    need to become href="../bar/".
for f in posts/*.html lists/*.html; do
  [ -f "$f" ] || continue
  perl -i -pe 's{href="([^/":#][^/":#]*/)"}{href="../$1"}g' "$f"
done

# 3. Rename every .html except root index.html → dir/index.html.
find . -name '*.html' ! -path './index.html' | while IFS= read -r f; do
  dir="${f%.html}"
  mkdir -p "$dir"
  mv "$f" "$dir/index.html"
done

cd ..
