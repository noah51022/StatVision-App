from flask import Flask, request, jsonify
import os
import pyrebase
import pandas as pd
from langchain_experimental.agents.agent_toolkits import create_pandas_dataframe_agent
from langchain.chat_models import ChatOpenAI
from langchain.agents import AgentExecutor
from langchain.agents.agent_types import AgentType
from langchain.llms import OpenAI


app = Flask(__name__)

# OpenAI API Key
os.environ["OPENAI_API_KEY"] = "API_KEY"

# Firebase configuration
config = {
  "apiKey": "API_KEY",
  "authDomain": "DOMAIN",
  "databaseURL": "DB_URL",
  "storageBucket": "STORAGE_BUCKET"
}

#Initalize firebase
firebase = pyrebase.initialize_app(config)

# access firebase database and save as a dataframe
db = firebase.database()
data = db.child("basketball_stats").get().val()

df = pd.DataFrame(data)

@app.route('/')
def hello_world():
    print("Working Successfully")
    return 'Hello from Flask!'

@app.route('/langchain')
def hello_langchain():
    return 'Hello from langchain'

@app.route('/get_stats', methods=['GET'])
def get_stats():
    query = request.args.get('query')

    # Create agent
    agent = create_pandas_dataframe_agent(
        ChatOpenAI(temperature=0, model="gpt-3.5-turbo-0613"),
        df,
        verbose=True,
        agent_type=AgentType.OPENAI_FUNCTIONS,
    )

    # Run the query
    result = agent.run(query)

    return jsonify({"result": result})

