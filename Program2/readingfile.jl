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
end

#****************
# Structure/object to hold formatted player data
#****************
struct formattedPlayer
    firstName::String
    lastName::String
    average::Float64
    slug::Float64
    onBasePercent::Float64
end

#****************
# Main section of program
#****************

#create data arrays
fileData = String[]
playerData = String[]

#prompting user for file name
println("Please enter the name of your player data file: ")
playerFile = chomp(readline())
println()

#open file
open(playerFile,"r") do file
count = 0
    for line in eachline(file)
        push!(fileData, line)
        count += 1
    end

    #parse individual player data from fileData array
    firstname = ""
    for i in 1:count
        playerData = split(fileData[i])
        firstname = playerData[1]
        lastname = playerData[2]
        println(firstname)
        println(lastname)
    end
end





#TODO: write sorting function
#TODO: write various player statistics calculation
#TODO: calculate player averages
#TODO: write function to return the path of the input file
#TODO: write function to read in input file
#TODO: write function to parse data file line by line
#TODO: write function to format final player report
#TODO: write main driver function
