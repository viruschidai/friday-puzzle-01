_ = require 'lodash'
readline = require 'readline'

###
Cookie Clicker is a Javascript game by Orteil, where players click on a picture of a giant cookie.
Clicking on the giant cookie gives them cookies.
They can spend those cookies to buy buildings.
Those buildings help them get even more cookies.
Like this problem, the game is very cookie-focused.
This problem has a similar idea, but it does not assume you have played Cookie Clicker.
Please don't go play it now: it might be a long time before you come back.

Problem

In this problem, you start with 0 cookies.
You gain cookies at a rate of 2 cookies per second.
Any time you have at least C cookies, you can buy a cookie farm.
Every time you buy a cookie farm, it costs you C cookies and gives you an extra F cookies per second.

Once you have X cookies that you haven't spent on farms, you win!
Figure out how long it will take you to win if you use the best possible strategy.

Example

Suppose C=500.0, F=4.0 and X=2000.0. Here's how the best possible strategy plays out:

You start with 0 cookies, but producing 2 cookies per second.
After 250 seconds, you will have C=500 cookies and can buy a farm that produces F=4 cookies per second.
After buying the farm, you have 0 cookies, and your total cookie production is 6 cookies per second.
The next farm will cost 500 cookies, which you can buy after about 83.3333333 seconds.
After buying your second farm, you have 0 cookies, and your total cookie production is 10 cookies per second.
Another farm will cost 500 cookies, which you can buy after 50 seconds.
After buying your third farm, you have 0 cookies, and your total cookie production is 14 cookies per second.
Another farm would cost 500 cookies, but it actually makes sense not to buy it: instead you can just wait until you have X=2000 cookies, which takes about 142.8571429 seconds.
Total time: 250 + 83.3333333 + 50 + 142.8571429 = 526.1904762 seconds.
Notice that you get cookies continuously: so 0.1 seconds after the game starts you'll have 0.2 cookies, and π seconds after the game starts you'll have 2π cookies.

Input

A Function that accepts 3 parameters:
 - the cost per farm (C)
 - the number of cookies per second (F)
 - the required amount of cookies to win (X)

C, F and X will each consist of at least 1 digit followed by 1 decimal point followed by from 1 to 5 digits. There will be no leading zeroes.

Output

The function needs to return the total number of seconds required to get to X cookies.
###
cache = {}

# Time take to create nth farm
exports.fTimeCostFarms = (n, cost, increment) ->
  if n is 0 then return 0
  if n is 1 then return cost / 2

  if cache[n] then return cache[n]
  t = exports.fTimeCostFarms(n-1, cost, increment) + cost / (2 + (n-1) * increment)
  cache[n] = t
  return t

# Time take if you need to build n farms
exports.fTime = (cost, increment, required, n) ->
  if n is 0 then return required / 2
  return exports.fTimeCostFarms(n, cost, increment) + (required / (2 + n * increment))


exports.answer = (cost, increment, required) ->
  cache = {}
  n =0
  # return time with n farms if n+1 farms take more time to reach the target than n farms
  while true
    t1 = exports.fTime(cost, increment, required, n)
    t2 = exports.fTime(cost, increment, required, n + 1)
    if t2 >= t1 then return t1 else n++


main = ->
  rl = readline.createInterface
    input: process.stdin,
    output: process.stdout

  rl.question 'Enter the cost of a cookie farm: ', (c) ->
    rl.question 'Enter how many cookies get produces by each farm per second: ', (f) ->
      rl.question 'Enter the total number of cookies required: ', (x) ->
        console.log "Total time to get #{+x} cookies = #{exports.answer(+c, +f, +x)} sec."
        rl.close()

main()
