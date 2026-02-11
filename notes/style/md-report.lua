-- -------------------------------------------------------------------------
-- pandoc filter: _md-report_.lua
--
-- @see: _md-report_.tex # maketitle|titlepage
-- @see: _LLM_Template_.md # YAML preamble
-- @see: Makefile
---
-- @see: https://aistudio.google.com/app/prompts?state=%7B%22ids%22:%5B%221npksKeOyqJG2RI1HAYntbWZqSnyrXWtu%22%5D,%22action%22:%22open%22,%22userId%22:%22101040866152128307883%22,%22resourceKeys%22:%7B%7D%7D&usp=sharing
-- @see: https://claude.ai/share/697fb160-e546-414a-8241-325f8b33571e
-- @see: https://chatgpt.com/share/6939a036-8ba8-8012-819c-aac93afad04e
-- @see: https://www.perplexity.ai/search/using-pandoc-to-convert-a-mark-Ob9r4V.rQsucZ69mwuNuiw#0
-- @see: https://chat.deepseek.com/a/chat/s/087ffbc3-196f-4ee5-bf7d-5ae173567462
-- @see: https://claude.ai/share/b28ceb6a-409e-4908-8519-4393d47a706e
-- -------------------------------------------------------------------------

local logging = require("logging")

function Meta(m)
	logging.temp(">>> ", rawget(_G, "FORMAT"), "#/meta:", m)

	if FORMAT ~= 'latex' then
	  return m
	end

        -- 0. Get temp directory from metadata
	local temp_dir = pandoc.utils.stringify(m.tempdir or "/tmp")
	
	-- Use FIXED filename in temp directory
	local temp_file = temp_dir .. "/pandoc-meta-commands.tex"
	
	logging.temp(">>> Using temp file:", temp_file)
        
        local header_lines = {}
        
	-- 1. Handle Keywords
	if m.keywords then
	  local kw_list = {}
	  -- Convert the list of keywords into a comma-separated string
	  for _, item in ipairs(m.keywords) do
	    table.insert(kw_list, pandoc.utils.stringify(item))
	  end
	  local kw_string = table.concat(kw_list, ", ")

	  -- Inject \keywords{...} into the header-includes
	  local kw_cmd = "\\keywords{" .. kw_string .. "}"
          table.insert(header_lines, kw_cmd)
          
          logging.temp("+++ ", rawget(_G, "FORMAT"), "#/meta(kw):", kw_cmd)
	end

	-- 2. Handle Abstract
        if m.abstract then

           local abstract_tex = pandoc.write(pandoc.Pandoc(m.abstract), 'latex')
           local abstract_cmd = "\\abstract{" .. abstract_tex .. "}"
           table.insert(header_lines, abstract_cmd)
           m.abstract = nil
           
        end

          -- z. Write to the unique temp file
        local f, err = io.open(temp_file, "w")
        if f then
           if #header_lines > 0 then
              f:write(table.concat(header_lines, "\n") .. "\n")
           else
              f:write("% No metadata commands\n")
           end
           f:close()
	  logging.temp("+++ Wrote to:", temp_file)
	else
	  logging.warning("!!! Could not write:", temp_file, err)
	end

	logging.temp("<<< ", rawget(_G, "FORMAT"), "#/meta:", m)
	return m
end

