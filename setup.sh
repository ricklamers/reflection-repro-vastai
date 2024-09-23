git clone https://github.com/glaive-ai/simple-evals
cd simple-evals
pip install -r requirements.txt

wget --header="Authorization: Bearer {{HF_TOKEN}}" https://huggingface.co/datasets/Idavidrein/gpqa/resolve/main/gpqa_main.csv

git clone https://github.com/openai/human-eval
cd human-eval
pip install -e .

# Download NLTK punkt tokenizer
python3 -c "import nltk; nltk.download('punkt'); nltk.download('punkt_tab')"

sed -i "58s/^#//" "human_eval/execution.py"