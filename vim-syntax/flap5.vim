syntax match ltransaction '^01.*$' contains=ltransactionPrefix
syntax match ltransactionPrefix '^01' contained nextgroup=ltransactiontype
syntax match ltransactiontype '.....' contained nextgroup=ltransactiondate
syntax match ltransactiondate '......' contained nextgroup=ltransactioncurrency
syntax match ltransactioncurrency '...' contained nextgroup=ltransactionsign
syntax match ltransactionsign '.' contained nextgroup=ltransactionamount
syntax match ltransactionamount '............' contained nextgroup=ltransactionprocesseddate
syntax match ltransactionprocesseddate '......' contained nextgroup=ltransactionupdateddate
syntax match ltransactionupdateddate '......' contained nextgroup=ltransactionacct
syntax match ltransactionacct '............' contained nextgroup=ltransactionflag
syntax match ltransactionflag '.' contained nextgroup=ltransactionstatus
syntax match ltransactionstatus '....' contained nextgroup=ltransactioncomment
syntax match ltransactioncomment '...................................................' contained nextgroup=ltransactionShouldEnd
syntax match ltransactionShouldEnd '.*' contained

syntax match lsummary '^99.*$' contains=lsummaryPrefix
syntax match lsummaryPrefix '^99' contained nextgroup=lsummarycount
syntax match lsummarycount '....' contained nextgroup=lsummarystatus
syntax match lsummarystatus '....' contained nextgroup=lsummarycomment
syntax match lsummarycomment '.........' contained nextgroup=lsummaryShouldEnd
syntax match lsummaryShouldEnd '.*' contained

highlight tblPrefix guifg=White guibg=DarkBlue
highlight tblWarn guifg=Red guibg=Red
highlight tblPlain guifg=Black guibg=Grey
highlight tblPlain2 guifg=White guibg=DarkGrey

highlight link ltransactionPrefix tblPrefix
highlight link ltransactiontype tblPlain
highlight link ltransactiondate tblPlain2
highlight link ltransactioncurrency tblPlain
highlight link ltransactionsign tblPlain2
highlight link ltransactionamount tblPlain
highlight link ltransactionprocesseddate tblPlain2
highlight link ltransactionupdateddate tblPlain
highlight link ltransactionacct tblPlain2
highlight link ltransactionflag tblPlain
highlight link ltransactionstatus tblPlain2
highlight link ltransactioncomment tblPlain
highlight link ltransactionShouldEnd tblWarn
highlight link lsummaryPrefix tblPrefix
highlight link lsummarycount tblPlain
highlight link lsummarystatus tblPlain2
highlight link lsummarycomment tblPlain
highlight link lsummaryShouldEnd tblWarn
