# Reproducing Eval Scores for Reflection 70B

This project provides a streamlined process to reproduce evaluation scores for the Reflection 70B model using the simple-evals framework. The setup and execution are automated using shell scripts and a deployment script.

Model: [Reflection-70B](https://huggingface.co/sahil280114/test-reflect)

## Prerequisites

- Access to a remote server (obtained from Vast.ai)
- SSH access to the remote server
- Python 3.x installed locally
- Git installed locally

## Setup

1. Clone this repository to your local machine.

2. Ensure you have the following files in your project directory:
   - `deploy.sh`: Main deployment script
   - `setup.sh`: Sets up the environment on the remote server
   - `process-1.sh`: Starts the vLLM server for Reflection 70B
   - `process-2.sh`: Runs the evaluation script
   - `templatefill.py`: Handles environment variable substitution
   - `.env`: Contains your OpenAI API key (ensure this file is not tracked by git)

3. Make sure `deploy.sh` is executable:
   ```
   chmod +x deploy.sh
   ```

## Deployment and Execution

1. Deploy the setup script to prepare the remote environment:
   ```
   ./deploy.sh setup.sh
   ```

2. Start the vLLM server for Reflection 70B:
   ```
   ./deploy.sh process-1.sh
   ```

3. Run the evaluation script:
   ```
   ./deploy.sh process-2.sh
   ```

## Notes

- The remote server details are defined in `deploy.sh`. Update the `REMOTE_SERVER` and `PORT` variables if necessary.
- The project uses the vLLM Docker image: `vllm/vllm-openai:latest (0.6.1.post2)` with CUDA version 12.4.
- The evaluation is performed using the simple-evals framework, which is automatically set up by the `setup.sh` script.
- Ensure your OpenAI API key is correctly set in the `.env` file.

## Troubleshooting

- If you encounter any issues with template filling, check the `templatefill.py` script and ensure all required environment variables are set.
- For any connection issues, verify that the remote server details in `deploy.sh` are correct and that you have proper SSH access.

## Security Note

Always keep your `.env` file and API keys secure. Never commit them to version control systems.
