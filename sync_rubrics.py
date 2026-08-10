import os
import re

def get_braced_value(start_idx, text_data):
    """Safely extracts content within the first balanced pair of braces it finds, ignoring spaces."""
    brace_count = 0
    real_start = -1
    for i in range(start_idx, len(text_data)):
        if text_data[i] == '{':
            if brace_count == 0:
                real_start = i # Mark the exact location of the opening brace
            brace_count += 1
        elif text_data[i] == '}':
            brace_count -= 1
            if brace_count == 0:
                # Return everything strictly inside the outer braces
                return text_data[real_start+1 : i]
    return ""

def sync_rubrics():
    if not os.path.exists('Main.aux'):
        print("[ERROR] Main.aux not found. Please compile Main.tex first.")
        return

    with open('Main.aux', 'r', encoding='utf-8') as f:
        # Flatten with a space to bypass all LaTeX line-wraps without fusing words
        aux_data = f.read().replace('\n', ' ').replace('\r', ' ')

    prefix_to_code = {}
    prefix_to_type = {}
    rubrics_db = {}

    print("Scanning Main.aux for active rubrics...\n")

    # 1. Extract Course Codes
    for m in re.finditer(r'\\global\s*\\@namedef\s*\{\s*course@(sem\d+@[a-z]+)@coursecode\s*\}', aux_data):
        prefix = m.group(1)
        val = get_braced_value(m.end(), aux_data)
        prefix_to_code[prefix] = val.strip().upper()

    # 2. Extract Course Types
    for m in re.finditer(r'\\global\s*\\@namedef\s*\{\s*course@(sem\d+@[a-z]+)@coursetype\s*\}', aux_data):
        prefix = m.group(1)
        val = get_braced_value(m.end(), aux_data)
        prefix_to_type[prefix] = val.strip()

    # 3. Extract Rubrics - Bulletproof regex for spaces
    pattern = r'\\global\s*\\@namedef\s*\{\s*master@([^@]+)@CIE@([A-Z])@text\s*\}'
    for m in re.finditer(pattern, aux_data):
        ctype = m.group(1).strip()
        letter = m.group(2).strip()
        val = get_braced_value(m.end(), aux_data)
        
        if ctype not in rubrics_db:
            rubrics_db[ctype] = {}
        rubrics_db[ctype][letter] = val

    print(f"DEBUG: Found rubrics in memory for these course types: {list(rubrics_db.keys())}\n")

    # Map Course Codes directly to Course Types
    course_type_map = {}
    for prefix, code in prefix_to_code.items():
        if prefix in prefix_to_type:
            course_type_map[code] = prefix_to_type[prefix]

    # 4. Check ALL .tex files
    updated_count = 0
    skipped_count = 0
    checked_count = 0
    
    for filename in os.listdir('.'):
        if filename.lower().endswith('.tex') and filename.lower() not in ['main.tex', 'creditdefinitions.tex']:
            course_code = filename[:-4].upper()

            if course_code in course_type_map:
                ctype = course_type_map[course_code]

                if ctype in rubrics_db:
                    with open(filename, 'r', encoding='utf-8') as f:
                        content = f.read()

                    new_rubrics_block = "% --- Editable CIE Rubrics ---\n"
                    for letter in sorted(rubrics_db[ctype].keys()):
                        new_rubrics_block += f"\\CIErubric{letter}{{{rubrics_db[ctype][letter]}}}\n"
                    new_rubrics_block += "\n\\outbpdocument"

                    pattern = r'% --- Editable CIE Rubrics ---.*?\\outbpdocument'
                    new_content = re.sub(
                        pattern, 
                        lambda m: new_rubrics_block, 
                        content, 
                        flags=re.DOTALL
                    )

                    if content != new_content:
                        with open(filename, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        print(f"[UPDATED] {filename} (Mapped to: {ctype})")
                        updated_count += 1
                    else:
                        print(f"[UP-TO-DATE] {filename} (Already has latest {ctype} rubrics)")
                        checked_count += 1
                else:
                    print(f"[WARNING] {filename} mapped to type '{ctype}', but NO rubrics found in memory!")
            else:
                skipped_count += 1

    print(f"\n[SUCCESS] Scan complete! {updated_count} updated, {checked_count} verified, {skipped_count} skipped.")

if __name__ == '__main__':
    sync_rubrics()