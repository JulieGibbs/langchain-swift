

-- Create a table to store your documents
create table documents (
  id bigserial primary key,
  content text,  -- corresponds to Document.pageContent
  embedding vector(1536)  -- 1536 works for OpenAI embeddings, change if needed
  metadata jsonb
);

-- Create a function to search for documents
create function match_documents(query_embedding vector(1536), match_count int)
returns table(id bigint, content text, similarity float)
language plpgsql
as $$
#variable_conflict use_column
begin
  return query
  select
    id,
    content,
    metadata,
    1 - (documents.embedding <=> query_embedding) as similarity
  from documents
  order by documents.embedding <=> query_embedding
  limit match_count;
end;
$$
;
