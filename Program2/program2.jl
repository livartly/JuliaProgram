using Printf
using Statistics

#TODO: write sorting function
#TODO: write function to FormatPlayer final player report
#TODO: Compute batting avg- sum of singles, doubles, triples, +home runs
#TODO: Compute slugging percentage- check sheet for formula
#TODO: Compute on base percentage- sum of walks, hitPitch divided by plate plateAppearances
#TODO: Compute overall batting avg
#TODO: Lots of error checking!

#****************
# Structure/Object to hold player data
#****************
mutable struct PlayerStruct
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
    slugging::Float64
    onBasePercent::Float64
    numberOfPlayers::Int32
end

#****************
# Structure/object to hold FormatPlayerted player data
#****************
mutable struct FormatPlayer
    firstName::String
    lastName::String
    average::Float64
    onBasePercent::Float64
    team::Vector{PlayerStruct}
    teamSize::Int32
end

# Compute individual player batting averages
function playerBattingAverage(player::PlayerStruct)
    player.battingAvg = (player.singles + player.doubles + player.triples + player.homeRuns) / (player.atBats)
end

# Compute team batting average
function teamBattingAverage(format::FormatPlayer)
    sumAverage = 0.0
    for i in 1:format.teamSize
        sumAverage += format.team[i].battingAvg
    end
    format.average = (sumAverage) / (format.teamSize)
end

# Compute individual player on base percentage
function playerOnBase(player::PlayerStruct)
    player.onBasePercent = (player.walks + player.hitPitch + player.singles + player.doubles + player.triples + player.homeRuns) / (player.plateApp)
end

# Compute individual player slugging
function playerSlugging(player::PlayerStruct)
    player.slugging = (player.singles + player.doubles * 2 + player.triples * 3 + player.homeRuns * 4) / (player.atBats)
end

# Sort team by last name
function Base.isless(i::PlayerStruct, j::PlayerStruct)
    if i.lastName < j.lastName
        return true
    end
    if (i.lastName == j.lastName) & (i.firstName < j.firstName)
        return true
    end
    return false
end

function printReport(playerReport::PlayerStruct)
    # Print team report
    println("BASEBALL TEAM REPORT --- " * string(playerReport.numberOfPlayers) * " players FOUND IN FILE")

    # Print overall batting average
    #@printf "OVERALL BATTING AVERAGE is %1.3f" playerReport.teamAverage
    println()
    println()

    # Print header of for player data
    print((" " ^ (25 - length("PLAYER NAME :"))) * "PLAYER NAME :")
    print((" " ^ (12 - length("AVERAGE"))) * "AVERAGE")
    print((" " ^ (12 - length("SLUGGING"))) * "SLUGGING")
    println((" " ^ (12 - length("ONBASE%"))) * "ONBASE%")
    println("---------------------------------------------------------------")

    #printing out player data using the printPlayer function
    for i in 1:playerReport.teamSize
        printPlayer(playerReport.team[i])
    end

    #TODO: print out errors and error headers
end

#formats the player data
function printPlayer(player::PlayerStruct)
    print((" " ^ (25 - length(player.lastName * ", " * player.firstName * " :"))) * player.lastName * ", " * player.firstName * " :")
    print(" " ^ (12 - length(@sprintf "%1.3f" player.average)) * (@sprintf "%1.3f" player.average))
    print(" " ^ (12 - length(@sprintf "%1.3f" player.slug)) * (@sprintf "%1.3f" player.slug))
    print(" " ^ (12 - length(@sprintf "%1.3f" player.onBasePercent)) * (@sprintf "%1.3f" player.onBasePercent))
end

#Main

#printing the welcome message
println("Welcome to the player statistics calculator test program! I am going to read team from an input data file, and you will tell me the name of your input file.")
println("I will store all of the team in a list, compute each player's averages and then write the resulting team report to your output file.")

#create data arrays
fileData = String[]
playerData = String[]
playerReport = FormatPlayer("", "", 0.0, 0.0, Vector{PlayerStruct}[], 0)

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
        hitbypitch = parse(Int32, playerData[10])
        battingaverage = 0.0
        slug = 0.0
        onbase = 0.0
        playernum = count

        #  Add new player to
        player = PlayerStruct(firstname, lastname, atbats, plateapp, singles, doubles, triples, homeruns, walks, hitbypitch, battingaverage, slug, onbase, playernum)
        playerReport.teamSize = count
        push!(playerReport.team, player)
    end
end

# Print report
for i in 1:playerReport.teamSize
    printReport(playerReport.team[i])
end

# Calculate player statistics
    #println("Team size ", playerReport.teamSize)
    #println("Function call:")
    #playerBattingAverage(playerReport.team[1])
    #playerSlugging(playerReport.team[1])
    #playerOnBase(playerReport.team[1])
    #teamBattingAverage(playerReport)
#end

# Testing
println(playerReport.team[1].homeRuns)
print("Name: ", playerReport.team[1].firstName)
println(playerReport.team[1].lastName)
println("At bats: ", playerReport.team[1].atBats)
println("Plate App: ", playerReport.team[1].plateApp)
println("Singles: ", playerReport.team[1].singles)
println("Doubles: ", playerReport.team[1].doubles)
println("Batting Avg" , playerReport.team[1].battingAvg)
println("Slugging: ", playerReport.team[1].slugging)
println("On Base: ", playerReport.team[1].onBasePercent)
println("Team Average: ", playerReport.average)
