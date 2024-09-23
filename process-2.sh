export OPENAI_API_KEY="{{OPENAI_API_KEY}}"
echo $OPENAI_API_KEY
cd simple-evals
python3 run_reflection_eval.py reflection_70b
# python3 run_reflection_eval.py llama_3.1_70b
# python3 run_reflection_eval.py llama_3.1_70b_reflection_prompt