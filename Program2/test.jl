using Printf

# A struct used to store a player's information
mutable struct Player
    firstName::String
    lastName::String
    plateAppearances::Int32
    atBats::Int32
    singles::Int32
    doubles::Int32
    triples::Int32
    homeRuns::Int32
    walks::Int32
    hitByPitch::Int32
    average::Float64
    slugging::Float64
    onBase::Float64
end

# A struct containing all the information in the database
mutable struct Report
    numOfPlayers::Int32
    totalAverage::Float64
    players::Vector{Player}
    numOfErrors::Int32
    errors::Vector{String}
end

# This method prints out the entire report
function printReport(r::Report)
    # Print team report
    println("BASEBALL TEAM REPORT --- " * string(r.numOfPlayers) * " PLAYERS FOUND IN FILE")

    # Print overall batting average
    @printf "OVERALL BATTING AVERAGE is %1.3f" r.totalAverage
    println()
    println()

    # Print header of for player data
    print((" " ^ (25 - length("PLAYER NAME :"))) * "PLAYER NAME :")
    print((" " ^ (12 - length("AVERAGE"))) * "AVERAGE")
    print((" " ^ (12 - length("SLUGGING"))) * "SLUGGING")
    println((" " ^ (12 - length("ONBASE%"))) * "ONBASE%")
    println("---------------------------------------------------------------")

    # Print player data
    for i in 1:r.numOfPlayers
        printPlayer(r.players[i])
    end

    # Print header for errors
    println()
    println("----- " * string(r.numOfErrors) * " ERROR LINES FOUND IN INPUT DATA -----")

    # Print Errors
    for i in 1:r.numOfErrors
        println(r.errors[i])
    end
end

# Method to calculate the total average for all the players in the report
function calculateTotalAverage(r::Report)
    sumAverage = 0.0
    for i in 1:r.numOfPlayers
        sumAverage += r.players[i].average
    end
    r.totalAverage = (sumAverage) / (r.numOfPlayers)
end

# Function to test if player i is less than player j. Based on lastname and then firstname
function Base.isless(i::Player, j::Player)
    if i.lastName < j.lastName
        return true
    end
    if (i.lastName == j.lastName) & (i.firstName < j.firstName)
        return true
    end
    return false
end


# This method prints out the player's data
function printPlayer(p::Player)
    print((" " ^ (25 - length(p.lastName * ", " * p.firstName * " :"))) * p.lastName * ", " * p.firstName * " :")
    print(" " ^ (12 - length(@sprintf "%1.3f" p.average)) * (@sprintf "%1.3f" p.average))
    print(" " ^ (12 - length(@sprintf "%1.3f" p.slugging)) * (@sprintf "%1.3f" p.slugging))
    println(" " ^ (12 - length(@sprintf "%1.3f" p.onBase)) * (@sprintf "%1.3f" p.onBase))
end

# This method computes player's average
function computeAverage(p::Player)
    p.average = (p.singles + p.doubles + p.triples + p.homeRuns) / (p.atBats)
end

# This method computes player's average
function computeSlugging(p::Player)
    p.slugging = (p.singles + p.doubles * 2 + p.triples * 3 + p.homeRuns * 4) / (p.atBats)
end

# This method computes player's average
function computeOnBasePercentage(p::Player)
    p.onBase = (p.walks + p.hitByPitch + p.singles + p.doubles + p.triples + p.homeRuns) / (p.plateAppearances)
end



#Begin main section of the program

#Initialize report struct
r = Report(0, 0, Vector{Player}[], 0, Vector{String}[])

#Print welcome message
println("Welcome to the player statistics calculator test program.")
println("I am going to read players from an input data file. You will tell me the name of your input file.")
println("I will store all of the players in a list, compute each player's averages and then ")
println("write the resulting team report to your output file.")
println()

#Prompt user for input file name
println("Enter the name of your input file: ")
fname = chomp(readline())
println()

#Read data from file in
fdata = String[]
try
    open(fname,"r") do f
        for line in eachline(f)
            push!(fdata, line)
        end
    end
catch
    println("FILE COULD NOT BE READ - EXITING")
    exit(0)
end

# Create player structs from data strings and add them to the report
for i in 1:length(fdata)
    pdata = split(fdata[i])

    #Catch error of player line not having enough/having too much data
    if length(pdata) != 10
        push!(r.errors, "line " * string(i) * ": Line contains incorrect amount of data.")
        r.numOfErrors += 1
        continue
    end

    # Read inputs into appropriate places and validate that the input is of the proper type
    fn = pdata[1]
    ln = pdata[2]
    pa = 0
    ab = 0
    si = 0
    db = 0
    tr = 0
    ho = 0
    wa = 0
    hbp = 0
    try
        pa = parse(Int32, pdata[3])
        ab = parse(Int32, pdata[4])
        si = parse(Int32, pdata[5])
        db = parse(Int32, pdata[6])
        tr = parse(Int32, pdata[7])
        ho = parse(Int32, pdata[8])
        wa = parse(Int32, pdata[9])
        hbp = parse(Int32, pdata[10])
    catch err
        push!(r.errors, "line " * string(i) * ": Line contains invalid numeric data.")
        r.numOfErrors += 1
        continue
    end

    #Add player to players list
    p = Player(fn, ln, pa, ab, si, db, tr, ho, wa, hbp, 0, 0, 0)
    push!(r.players, p)
    r.numOfPlayers += 1
end

# Calculate averages, sluggings, onBasePercentages and totalAverage
for i in 1:r.numOfPlayers
    computeAverage(r.players[i])
    computeSlugging(r.players[i])
    computeOnBasePercentage(r.players[i])
end
calculateTotalAverage(r)

# Sort players by lastName (Using firstName to break ties)
r.players = sort(r.players)

#Print report
printReport(r)
