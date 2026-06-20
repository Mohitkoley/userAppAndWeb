---
trigger: always_on
description: Consult the graphify knowledge graph at graphify-out/ for codebase and architecture questions.
---

## graphify

This project has a graphify knowledge graph at graphify-out/.

Rules:
- CRITICAL MANDATE: Before taking ANY action, planning, or answering ANY question regarding this project, you MUST FIRST ask graphify for context. Run `graphify query "<question>"` (CLI) or use `query_graph` (MCP).
- ONLY IF graphify does not return sufficient information are you allowed to use raw `grep_search`, `list_dir`, or read files on your own.
- Use `graphify path "<A>" "<B>"` / `shortest_path` for relationships and `graphify explain "<concept>"` / `get_node` for focused concepts.
- If graphify-out/wiki/index.md exists, navigate it instead of reading raw files
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context
- After modifying code files in this session, run `graphify update .` to keep the graph current (AST-only, no API cost)
