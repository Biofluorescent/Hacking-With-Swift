import Foundation

//Some Random Methods introduced in Swift 4.2
let int1 = Int.random(in: 0...10)
let int2 = Int.random(in: 0..<10)
let double1 = Double.random(in: 1000...10000)
let float1 = Float.random(in: -100...100)

//Older random functions
//0 to 4_294_967_295
print(arc4random())
print(arc4random())
print(arc4random())
print(arc4random())

//Slightly problematic range of numbers, produces modulo bias
print(arc4random() % 6)

//Smarter way. No seeding required, no modulo bias
//Range must be 0 to MAX. Only works with non-negative Ints
print(arc4random_uniform(6))

//Ugly function required to make min other than 0
func RandomInt(min: Int, max: Int) -> Int {
    if max < min { return min }
    return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
}

//-----------------------------------------------------------------

import GameplayKit

// -2_147_483_648 to 2_147_483_647
//Not guaranteed to be random for very specific situations
print(GKRandomSource.sharedRandom().nextInt())

//Use instead
print(GKRandomSource.sharedRandom().nextInt(upperBound: 6))
//Also available: nextBool(), nextUniform()


//GameplayKit has 3 custom sources of random numbers, all deterministic and can be serializsed.
//Allows for network play to be synchronized and cheaters unable to force their way around your game.

//GKLinearCongruentialRandomSource - High performance, low randomness

//Good performance and randomness
let arc4 = GKARC4RandomSource()
//0 to 19
arc4.nextInt(upperBound: 20)

//High randomness, low performance
let mersenne = GKMersenneTwisterRandomSource()
mersenne.nextInt(upperBound: 20)

//Apple recommends flushing generator to avoid guessable sequences
arc4.dropValues(1024)

//-----------------

//GameplayKit allows you to shape random sources using random distributions
let d6 = GKRandomDistribution.d6()
let d20 = GKRandomDistribution.d20()
//Inclusive
let crazy = GKRandomDistribution(lowestValue: 1, highestValue: 11539)

d6.nextInt()
d20.nextInt()
crazy.nextInt()

//Be careful though, this will crash
var distribution = GKRandomDistribution(lowestValue: 10, highestValue: 20)
// print(distribution.nextInt(upperBound: 9))


//If you want to use a particular random source...
let rand = GKMersenneTwisterRandomSource()
distribution = GKRandomDistribution(randomSource: rand, lowestValue: 10, highestValue: 20)
print(distribution.nextInt())


//This distribution ensure sequences occur less frequently.
//But it will give every value once randomly before starting over again.
//i.e. 1 to 6 randomly then 1 to 6 again randomly
let shuffled = GKShuffledDistribution.d6()
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())

//Also GKGaussianDistribution that ensure results form a natural bell curve
//Results near the mean occur more frequently


//------------------

//Array shuffling

//Many Swift game project use this Fisher-Yates in-place array shuffle algorithm
extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swapAt(i, j)
        }
    }
}

//GameplayKit has a similar method that returns a new array
let lotteryBalls = [Int](1...49)
let shuffledBalls = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lotteryBalls)
print(shuffledBalls[0])
print(shuffledBalls[1])
print(shuffledBalls[2])
print(shuffledBalls[3])
print(shuffledBalls[4])
print(shuffledBalls[5])


//You can seed the randomization source. Could use to synchronize players in network game
let fixedLotteryBalls = [Int](1...49)
let fixedShuffledBalls = GKMersenneTwisterRandomSource(seed: 1001).arrayByShufflingObjects(in: fixedLotteryBalls)
print(fixedShuffledBalls[0])
print(fixedShuffledBalls[1])
print(fixedShuffledBalls[2])
print(fixedShuffledBalls[3])
print(fixedShuffledBalls[4])
print(fixedShuffledBalls[5])
