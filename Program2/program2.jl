#Programming Languages
#Program 2

using Printf
using Statistics
startString = "Starting program..."
println(startString)


println("Enter file name")
fileName = chomp(readline())
println()

fileData = String[]
try
    open(fileName,"r") do f
        for line in eachline(f)
            push!(fileData, line)
        end
    end
catch
    println("Error reading data")
    exit(0)
