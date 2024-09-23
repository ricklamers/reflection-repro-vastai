cd simple-evals/ifeval
python3 gen_results.py --model_name="glaiveai/Reflection-Llama-3.1-70B"
# python3 gen_results.py --model_name="meta-llama/Meta-Llama-3.1-70B-Instruct" --no-reflection
# python3 gen_results.py --model_name="meta-llama/Meta-Llama-3.1-70B-Instruct"
python3 -m evaluation_main \
  --input_data=./data/ifeval_input_data.jsonl \
  --input_response_data=./data/reflection_output.jsonl \
  --output_dir=./data/ | tee result.txt