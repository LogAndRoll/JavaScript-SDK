makeK = -> return {nice: Math.round(Math.random() * 100)}
compareNice = (a, b) ->
  if a.nice > b.nice
    return -1
  else if (a.nice < b.nice)
    return 1

  return 0

a = []
a.push(makeK()) for i in [0..55]
console.log a
a.sort(compareNice)
console.log a
