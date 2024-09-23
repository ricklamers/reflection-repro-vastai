import os
import glob

def dump_files(output_file):
    with open(output_file, 'w', encoding='utf-8') as outfile:
        for folder in glob.glob('benchmark*'):
            for filepath in glob.glob(f'{folder}/**/*', recursive=True):
                if os.path.isfile(filepath) and not filepath.endswith('.html') and not filepath.endswith('.jsonl'):
                    outfile.write(f"<file {filepath}>\n")
                    try:
                        with open(filepath, 'r', encoding='utf-8') as infile:
                            outfile.write(infile.read())
                    except UnicodeDecodeError:
                        outfile.write("<<Binary file, contents not shown>>\n")
                    outfile.write("</file>\n\n")

if __name__ == "__main__":
    output_file = "benchmark_contents_dump.txt"
    dump_files(output_file)
    print(f"All non-HTML and non-JSONL files have been dumped to {output_file}")
