git clone https://github.com/sahil280114/simple-evals
cd simple-evals
pip install -r requirements.txt

git clone https://github.com/openai/human-eval
cd human-eval
pip install -e .

# Needed for outlines compatibility
pip install "numpy<2" tabulate

sed -i "58s/^#//" "human_eval/execution.py"

cd ..
# Replace shareweights/v5_70_bf16 with sahil2801/test-reflect in run_reflection_eval.py
sed -i 's/shareweights\/v5_70_bf16/sahil2801\/test-reflect/g' run_reflection_eval.py
