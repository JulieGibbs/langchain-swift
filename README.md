# 🐇 LangChain Swift
[![Swift](https://github.com/buhe/langchain-swift/actions/workflows/swift.yml/badge.svg)](https://github.com/buhe/langchain-swift/actions/workflows/swift.yml) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A serious and mini swift langchain copy, for ios or mac apps.


## Setup
1. Create env.txt file in main project.
2. Set some var like OPENAI_API_KEY or OPENAI_API_BASE

Like this.

```
OPENAI_API_KEY=sk-xxx
OPENAI_API_BASE=xxx
SUPABASE_URL=xxx
SUPABASE_KEY=xxx
```

### Support env var
- OPENAI_API_KEY
- OPENAI_API_BASE
- SUPABASE_URL
- SUPABASE_KEY

## Get stated
### 💬 Chatbots

### ❓ QA bot
Code
```swift
let loader = TextLoader(file_path: "state_of_the_union.txt")
let documents = loader.load()
let text_splitter = CharacterTextSplitter(chunk_size: 1000, chunk_overlap: 0)

let embeddings = OpenAIEmbeddings()
let s = Supabase(embeddings: embeddings)
Task {
    for text in documents {
        let docs = text_splitter.split_text(text: text.page_content)
        for doc in docs {
            await s.addText(text: doc)
        }
    }
    
    let m = await s.similaritySearch(query: "What did the president say about Ketanji Brown Jackson", k: 1)
    print("Q:What did the president say about Ketanji Brown Jackson")
    print("A:\(m)")
}
```
Log
```
Q:What did the president say about Ketanji Brown Jackson
A:[LangChain.MatchedModel(content: Optional("In state after state, new laws have been passed, not only to suppress the vote, but to subvert entire elections. We cannot let this happen. Tonight. I call on the Senate to: Pass the Freedom to Vote Act. Pass the John Lewis Voting Rights Act. And while you’re at it, pass the Disclose Act so Americans can know who is funding our elections. Tonight, I’d like to honor someone who has dedicated his life to serve this country: Justice Stephen Breyer—an Army veteran, Constitutional scholar, and retiring Justice of the United States Supreme Court. Justice Breyer, thank you for your service. One of the most serious constitutional responsibilities a President has is nominating someone to serve on the United States Supreme Court. And I did that 4 days ago, when I nominated Circuit Court of Appeals Judge Ketanji Brown Jackson. One of our nation’s top legal minds, who will continue Justice Breyer’s legacy of excellence. "), similarity: 0.80242604)]
```
### 🤖 Agent
Code
```swift
let agent = initialize_agent(llm: llm, tools: [WeatherTool()])
let answer = await agent.run(args: "Query the weather of this week")
print(answer)
```
Log
```
Answer the following questions as best you can. You have access to the following tools:

Weather:useful for When you want to know about the weather

Use the following format:

Question: the input question you must answer
Thought: you should always think about what to do
Action: the action to take, should be one of [Weather]
Action Input: the input to the action
Observation: the result of the action
... (this Thought/Action/Action Input/Observation can repeat N times)
Thought: I now know the final answer
Final Answer: the final answer to the original input question

Begin!

Question: Query the weather of this week
Thought:     This was your previous work
    but I haven't seen any of it! I only see what "
    you return as final answer):
I need to know the location for which I want to check the weather
Action: Weather
Action Input: Location
Observation: Sunny^_^
Thought: I need to know the specific days for which I want to check the weather
Action: Weather
Action Input: Days of the week
Observation: Sunny^_^
Thought: 
final answer.
 The weather for the specified location and days of the week is sunny.
```
## Roadmap
- [ ] LLMs
  - [x] OpenAI
- [ ] Vectorstore
  - [x] Supabase
- [ ] Embedding
  - [x] OpenAI
- [ ] Chain
  - [x] Base
  - [x] LLM
- [ ] Tools
  - [x] Dummy
  - [x] InvalidTool
  - [ ] Serper
  - [ ] Zapier
- [ ] Agent
  - [x] ZeroShotAgent
- [ ] Memory
- [ ] Text Splitter
    - [x] CharacterTextSplitter
- [ ] Document Loader
    - [x] TextLoader

## 💁 Contributing
As an open-source project in a rapidly developing field, we are extremely open to contributions, whether it be in the form of a new feature, improved infrastructure, or better documentation.
