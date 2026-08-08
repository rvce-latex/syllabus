import os
import re

def roman_to_arabic(roman_str):
    """Converts the Roman numeral index from Main.aux into an Arabic integer."""
    roman_vals = {'i': 1, 'v': 5, 'x': 10, 'l': 50, 'c': 100}
    arabic = 0
    roman_str = roman_str.lower()
    
    for i in range(len(roman_str)):
        if i > 0 and roman_vals[roman_str[i]] > roman_vals[roman_str[i - 1]]:
            arabic += roman_vals[roman_str[i]] - 2 * roman_vals[roman_str[i - 1]]
        else:
            arabic += roman_vals[roman_str[i]]
    return str(arabic)

def sync_course_files():
    # 1. Ensure Main.aux exists so we have the latest memory map
    if not os.path.exists('Main.aux'):
        print("[ERROR] Main.aux not found. Please compile Main.tex first.")
        return

    course_map = {}
    
    # 2. Extract accurate semester and index data directly from Main.aux
    with open('Main.aux', 'r', encoding='utf-8') as f:
        aux_data = f.read()
        
    # Regex to grab \global\@namedef{course@originsem@COURSECODE}{SEM}
    sems = re.findall(r'\\global\\@namedef\{course@originsem@([^}]+)\}\{(\d+)\}', aux_data)
    # Regex to grab \global\@namedef{course@origincidx@COURSECODE}{ROMAN_INDEX}
    idxs = re.findall(r'\\global\\@namedef\{course@origincidx@([^}]+)\}\{([a-z]+)\}', aux_data)
    
    sem_dict = dict(sems)
    idx_dict = dict(idxs)
    
    # Build a master dictionary connecting Course Code -> (Semester, Arabic Index)
    for code in sem_dict:
        if code in idx_dict:
            arabic_idx = roman_to_arabic(idx_dict[code])
            course_map[code] = (sem_dict[code], arabic_idx)

    # 3. Process all .tex files in the directory
    updated_count = 0
    for filename in os.listdir('.'):
        if filename.endswith('.tex') and filename not in ['Main.tex', 'CreditDefinitions.tex']:
            course_code = filename[:-4] # Extract course code from filename
            
            # If the file matches a course mapped in Main.aux
            if course_code in course_map:
                target_sem, target_idx = course_map[course_code]
                
                with open(filename, 'r', encoding='utf-8') as f:
                    content = f.read()
                    
                # Regex to cleanly replace \initstandalone{...}{...}
                new_content = re.sub(
                    r'\\initstandalone\{[^{}]*\}\{[^{}]*\}', 
                    f'\\\\initstandalone{{{target_sem}}}{{{target_idx}}}', 
                    content
                )
                
                # Regex to cleanly replace \begin{course}{...}{...}
                new_content = re.sub(
                    r'\\begin\{course\}\{[^{}]*\}\{[^{}]*\}', 
                    f'\\\\begin{{course}}{{{target_sem}}}{{{target_idx}}}', 
                    new_content
                )
                
                # Only rewrite the file if changes were actually made
                if content != new_content:
                    with open(filename, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    print(f"[SYNCED] {filename} -> Semester {target_sem}, Index {target_idx}")
                    updated_count += 1

    print(f"\n[SUCCESS] Sync complete! {updated_count} course files updated.")

if __name__ == '__main__':
    sync_course_files()