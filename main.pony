// We are using total 3 actors for this problem
// 1. 
// Main Actor - to take the input and show the final result
// takes input and shows the final result
// 2. 
// SquareWorker - calculate squares for each number from 1 to N + K - 1
// 3. 
// SquareTask
// calculates the sum of k consective numbers
// 4. 
// SquareValidator
// to check if number is square or not

use "collections"
use "math"

class MathOps

  fun round_up(x: F64): USize =>
    let int_part = x.trunc().i64()
    let frac_part = x - int_part.f64()

    if frac_part > 0.0 then
      (int_part + 1).usize()
    else
      int_part.usize()
    end

  fun square_root(n: USize): F64 =>
    if n == 0 then
      return 0
    end
    if n == 1 then
      return 1
    end

    n.f64().pow(0.5)

actor SquareWorker
  let _env: Env
  let _total: USize
  let _chunkSize: USize
  let _tasks: Array[SquareTask]

  new create(env: Env, n: USize, k: USize) =>
    _env = env
    _total = n

    if n <= 1000 then
      _chunkSize = n
    else
      _chunkSize = MathOps.round_up(MathOps.square_root(n))
    end

    _tasks = Array[SquareTask]

    let taskCount = ((n - 1) / _chunkSize) + 1
    for i in Range(0, taskCount) do
      _tasks.push(SquareTask(env, k, i * _chunkSize))
    end

    for i in Range(0, taskCount) do
      let startIdx = (i * _chunkSize) + 1
      let endIdx = if ((i + 1) * _chunkSize) > n then n else (i + 1) * _chunkSize end
      try
        _tasks(i)?.compute_chunk(startIdx, endIdx)
      end
    end

actor SquareTask
  let _env: Env
  let _k: USize
  let _offset: USize
  let _values: Array[U64]
  var _sum: U64
  var _currentIndex: USize
  let _checker: SquareValidator

  new create(env: Env, k: USize, offset: USize) =>
    _env = env
    _k = k
    _offset = offset
    _values = Array[U64](_k)
    _sum = 0
    _currentIndex = 0
    _checker = SquareValidator(env)

  be compute_chunk(startIdx: USize, endIdx: USize) =>
    for i in Range(startIdx, endIdx + 1) do
      let square = i.u64() * i.u64()
      add_square(square, startIdx)
    end

  fun ref add_square(square: U64, startIdx: USize) =>
    if _values.size() == _k then
      try
        _sum = _sum - _values.shift()?
      end
    end

    _values.push(square)
    _sum = _sum + square

    if _values.size() == _k then
      _checker.validate_square(_sum, _offset + _currentIndex)
      _currentIndex = _currentIndex + 1
    end

actor SquareValidator
  let _env: Env
  let _results: Array[Bool]

  new create(env: Env) =>
    _env = env
    _results = Array[Bool]

  be validate_square(n: U64, index: USize) =>
    let isSquare = check_perfect_square(n)

    if isSquare then
      _env.out.print((index + 1).string())
    end

    _results.push(isSquare)

  fun check_perfect_square(n: U64): Bool =>
    if (n == 0) or (n == 1) then
      return true
    end

    let n_f64 = n.f64()
    let sqrtVal = n_f64.pow(0.5)
    let roundedSqrt = sqrtVal.round()

    let squaredRoundedSqrt = roundedSqrt * roundedSqrt

    squaredRoundedSqrt == n_f64

actor Main
  new create(env: Env) =>
    try
      let n = env.args(1)?.usize()?
      let k = env.args(2)?.usize()?
      SquareWorker(env, n + k, k)
    else
      env.out.print("Please provide valid inputs for N and K.")
    end