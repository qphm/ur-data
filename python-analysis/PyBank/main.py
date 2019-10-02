import os
import csv

financial_csv = os.path.join('..', 'PyBank', 'budget_data.csv')

months = 0
net_total = 0
total_rev = 0
pre_rev = 0

revenue = []
monthly_changes = []
date = []

with open('budget_data.csv') as csvfile:
    csvreader = csv.reader(csvfile, delimiter=",")
    csv_header = next(csvfile)

    for row in csvreader:
        months += 1
        net_total += int(row[1])
        
        current_rev = int(row[1])
        monthly_rev = current_rev - pre_rev
        pre_rev = current_rev
        total_rev += monthly_rev
        avg_rev = total_rev/months
    
        date.append(row[0])
        revenue.append(row[1])
        monthly_changes.append(monthly_rev)

        greatincrease = max(monthly_changes)
        greatdecrease = min(monthly_changes)

print("Financial Analysis")
print("----------------------------")
print("Total Months: " + str(months))
print("Total: " + "$" + str(net_total))
print("Average Change: " + "$" + str(avg_rev))
print("Greatest Increase in Profits: " + str(date[monthly_changes.index(max(monthly_changes))]) + " " + "($" + str(greatincrease) + ")")
print("Greatest Decrease in Profits: " + str(date[monthly_changes.index(min(monthly_changes))]) + " " + "($" + str(greatdecrease) + ")")

file = open("output.txt","w")
file.write("Financial Analysis" + "\n")
file.write("----------------------------" + "\n")
file.write("Total Months: " + str(months) + "\n")
file.write("Total: " + "$" + str(net_total) + "\n")
file.write("Average change: " + "$" + str(avg_rev) + "\n")
file.write("Greatest Increase in Profits: " + str(date[monthly_changes.index(max(monthly_changes))]) + " " + "($" + str(greatincrease) + ")" + "\n")
file.write("Greatest Decrease in Profits: " + str(date[monthly_changes.index(min(monthly_changes))]) + " " + "($" + str(greatdecrease) + ")" + "\n")
file.close()