##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            --
##----------- THIS SCRIPT WILL CREATE FLOWCHART FOR OUR ANALYSIS.---------------
##                                                                            --
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Load in all necessary packages
library(tidyverse)
library(here)
library(DiagrammeR)

flowchart_fig <- grViz("digraph {

## Initiate graph
graph [layout = dot, rankdir = LR, label = 'EDS-214 Flowchart\n\n',labelloc = t, fontsize = 50]

## Global node settings
node [shape = rectangle, style = filled, fillcolor = Linen]

## Label nodes
data1 [label = 'Quebrada one-Bisley (Q1)', shape = folder, fillcolor = Beige]
data2 [label = 'Quebrada one-Bisley (Q2)', shape = folder, fillcolor = Beige]
data3 [label = 'Quebrada one-Bisley (Q3)', shape = folder, fillcolor = Beige]
data4 [label = 'Puente Roto Mameyes (MPR)', shape = folder, fillcolor = Beige]
join [label = 'Function \n Full-join streams (BQ1/BQ2/BQ3/PRM)']
tidy [label =  'Function \n clean_names() + \n pivot_longer()']
filter[label = 'Function \n Filter nutrients (K, NO3-N, Mg, Ca, NH4-N) & \n years 1988–1994']
moving_average [label = 'Function \nmoving_average.R\ \n(9-week mean)']
params [label = 'Parameter\\nwin_size_wks = 9\\n nutrients = K, NO3-N, Mg, Ca, NH4-N\\nHugo = 1989-09-18', shape = diamond, fillcolor = steelblue]
visual [label = 'Visual\\n5-panel time series\\n ggplot + patchwork', shape = hexagon, fillcolor = red]
output [label = 'Output\\nFigure 3 replica', shape = ellipse, fillcolor = green]


## Edge definitions with the node IDs
{data1 data2 data3 data4}  -> join -> tidy -> filter -> moving_average
params -> moving_average -> visual -> output

}")

flowchart_fig
