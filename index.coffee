Comparer = require "./comparer"

comparer = new Comparer process.argv[2]
comparer.printSameFileGroups()