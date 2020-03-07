using Printf
using Statistics

#****************
# Structure/Object to hold player data
#****************
struct Player
    firstName::String
    lastName::String
    atBats::UInt64
    plateApp::UInt64
    singles::UInt64
    doubles::UInt64
    triples::UInt64
    homeRuns::UInt64
    walks::UInt64
    hitPitch::UInt64
    battingAvg::Float64
end

#****************
# Structure/object to hold formatted player data
#****************
struct formattedP
    firstName::String
    lastName::String
    average::Float64
    slug::Float64
    onBasePercent::Float64
    team::Vector{Player}
end

#create data arrays
fileData = String[]
playerData = String[]
playerReport = formattedP("", "", 0.0, 0.0, 0.0, Vector{Player}[])

#prompting user for file name
println("Please enter the name of your player data file: ")
playerFile = chomp(readline())
println()

#open file
open("julia.txt","r") do file
count = 0
    for line in eachline(file)
        push!(fileData, line)
        count += 1
    end

    #parse individual player data from fileData array
    for i in 1:count
        playerData = split(fileData[i])
        firstname = playerData[1]
        lastname = playerData[2]
        atbats = parse(Int32, playerData[3])
        plateapp = parse(Int32, playerData[4])
        singles = parse(Int32, playerData[5])
        doubles = parse(Int32, playerData[6])
        triples = parse(Int32, playerData[7])
        homeruns = parse(Int32, playerData[8])
        walks = parse(Int32, playerData[9])
        hitbypitch = parse(Int32, playerData[10]
        battingaverage = 0.0

        #add new player to
        player = Player(firstname, lastname, atbats, plateapp, singles, doubles, triples, homeruns, walks, hitbypitch, battingaverage)
        push!(playerReport.team, player)
    end
end

println(playerReport.team[1].homeRuns)

#TODO: write sorting function
#TODO: write function to format final player report
#TODO: Compute batting avg- sum of singles, doubles, triples, +home runs
#TODO: Compute slugging percentage- check sheet for formula
#TODO: Compute on base percentage- sum of walks, hitPitch divided by plate plateAppearances
#TODO: Compute overall batting avg
