set positional-arguments

[private]
mod formatting 'modern-format.just'

[arg('language', pattern='all|rust|ts')]
[arg('check', long, value='true')]
format language='all' check='false':
    just formatting::{{language}} {{if check == 'true' { '--check' } else { '' }}}

check: (formatting::all 'true')
