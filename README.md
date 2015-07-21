== Throw something at the wall, it sticks
use for testing callbacks

try it:
`curl -v -XPOST -d post_body http://throwitatthewall.com/arbitrary_key`
`curl -v -XGET http://throwitatthewall.com/arbitrary_key`
`curl -v -XDELETE http://throwitatthewall.com/arbitrary_key`
`curl -v -XGET http://throwitatthewall.com/arbitrary_key`
