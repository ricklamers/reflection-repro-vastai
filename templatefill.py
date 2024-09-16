import os
import re
import shutil
import tempfile

def process_script(input_path, output_path):
    with open(input_path, 'r') as file:
        content = file.read()

    def replace_env_var(match):
        var_name = match.group(1)
        env_value = os.environ.get(var_name)
        if env_value is None:
            raise ValueError(f"Template filling failed for variable {var_name}")
        return env_value

    processed_content = re.sub(r'\{\{(\w+)\}\}', replace_env_var, content)

    with tempfile.NamedTemporaryFile(mode='w', delete=False) as temp_file:
        temp_file.write(processed_content)
        temp_path = temp_file.name

    shutil.move(temp_path, output_path)

    return output_path

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 3:
        print("Usage: python templatefill.py <input_file> <output_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]

    try:
        result = process_script(input_file, output_file)
        print(f"Processed file saved to: {result}")
    except ValueError as e:
        print(f"Error: {str(e)}")
        sys.exit(1)
