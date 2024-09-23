# Reproducing Eval Scores for Reflection 70B on Vast.ai

This project provides a streamlined process to reproduce evaluation scores for the Reflection 70B model using the simple-evals framework. The setup and execution are automated using shell scripts and a management script and assumes a Vast.ai 4x GPU instance (A100 or H100).

Model: [Reflection-70B](https://huggingface.co/glaiveai/Reflection-Llama-3.1-70B)

> [!NOTE]
> This project uses the [Glaive fork of simple-evals](https://github.com/glaive-ai/simple-evals), which includes custom answer extraction logic for Reflection reasoning token outputs.

## Achieved Results

| Benchmark | Reflection 70B | Llama 3.1 70B Reflection system prompt | Llama 3.1 70B default system prompt |
|-----------|----------------|----------------------------------------|-------------------------------------|
| MMLU      | 0.9227         | 0.8446                                 | 0.8470                              |
| GPQA      | 0.5781         | 0.4330                                 | 0.4107                              |
| HumanEval | 0.8659         | 0.6707                                 | 0.8232                              |
| IFEval    | 0.8711         | 0.8396                                 | 0.8939                              |
| MATH      | 0.6994         | 0.6482                                 | 0.5570                              |
| GSM8K     | 0.9447         | 0.9401                                 | 0.9522                              |

### IFEval
Is the average of loose/strict of prompt-level and instruction-level (so average of 4 scores).

## Prerequisites

- Access to a remote server (obtained from Vast.ai)
- SSH access to the remote server
- Python 3.x installed locally

## Setup

1. Clone this repository to your local machine.

2. Ensure you have the following files in your project directory:
   - `manage.sh`: Main management script
   - `setup.sh`: Sets up the environment on the remote server
   - `process-1.sh`: Starts the vLLM server for Reflection 70B
   - `process-2.sh`: Runs the evaluation script
   - `process-3.sh`: Runs the IFEval script
   - `templatefill.py`: Handles environment variable substitution
   - `.env`: Contains your OpenAI API key/Vast.ai SSH information, HF token (see .env.example)

3. Make sure `manage.sh` is executable:
   ```
   chmod +x manage.sh
   ```

## Deployment and Execution

1. Deploy the setup script to prepare the remote environment:
   ```
   ./manage.sh setup.sh
   ```

2. Start the vLLM server for Reflection 70B:
   ```
   ./manage.sh process-1.sh
   ```

3. Run the evaluation script (run after vLLM is ready):
   ```
   ./manage.sh process-2.sh
   ```

4. Run the IFEval script (run after vLLM is ready):
   ```
   ./manage.sh process-3.sh
   ```

## Notes

- The remote server details are defined in `manage.sh`. Update the `REMOTE_SERVER` and `PORT` variables if necessary.
- The project uses the vLLM Docker image: `vllm/vllm-openai:latest (0.6.1.post2)` with CUDA version 12.4.
- The evaluation is performed using the simple-evals framework, which is automatically set up by the `setup.sh` script.
- Ensure your OpenAI API key is correctly set in the `.env` file.
- vLLM is run with tensor parallelism 4 so it assumes a 4x GPU setup. You can change this in `process-1.sh` and use 8x GPUs if you want to speed things up.

## Troubleshooting

- If you encounter any issues with template filling, check the `templatefill.py` script and ensure all required environment variables are set.
- For any connection issues, verify that the remote server details in `manage.sh` are correct and that you have proper SSH access.
