# Problem Set X.X.X: <Descriptive Title Here>
# File: filename.py
# Date: 1 January 2019
# By: Full Name
# Login ID
# Section: Number
# Team: Team Number
#
# ELECTRONIC SIGNATURE
# Full Name
#
# The electronic signature above indicates that the program
# submitted for evaluation is my individual work. I have
# a general understanding of all aspects of its development
# and execution.
#
# A BRIEF DESCRIPTION OF WHAT THE PROGRAM OR FUNCTION DOES
#---------------------------------------------------
#  Inputs
#---------------------------------------------------
import csv
import matplotlib.pyplot as plt

ballPyt = "BallPython_cleaned_feeding_data.csv"
salazar = "Salazar_cleaned_feeding_data.csv"

#---------------------------------------------------
#  Computations
#---------------------------------------------------
with open(ballPyt) as csvfile:
    dataBall = csv.DictReader(csvfile, delimiter = ';', quotechar = '|')
    months = []
    year = []
    consumed = []
    
    for row in dataBall:
        consumption = int(row['Consumed'])
        consump_year = int(row['Year'])
        month = (row['Month'])
        consumed.append(consumption)
        months.append(month)
        year.append(consump_year)
        
    for x in range(len(months)):
        print("On", months[x], ",", year[x], "the ball python ate", consumed[x], "mice.")
        plt.plot(months, consumed, label ="Consumed by Ball Python", marker = 'o')
        
with open(salazar) as csvfile:
    dataPython = csv.DictReader(csvfile, delimiter = ';', quotechar = '|')
    months = []
    year = []
    consumed = []
    
    for row in dataPython:
        consumption2 = int(row['Consumed'])
        consump_year2 = row['Year']
        month2 = row['Month']
        consumed.append(consumption2)
        months.append(month2)
        year.append(consump_year2)
        
    for x in range(len(months)):
        print("On", months[x], ",", year[x], "Salazar ate", consumed[x], "mice.")


#---------------------------------------------------
#  Graphs
#---------------------------------------------------
  
plt.plot(months, consumed, label ="Consumed Salazar", marker = 'o')
plt.title('Number of Mice Eaten vs Month')
plt.xlabel('Months')
plt.ylabel('Consumed by Ball Python')   
plt.show()        
        
        
        
        
        
        
        
        
        
        
        
        
        