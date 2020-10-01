## Description

This depository includes the data and the Stata code used in Ioannidis K., Offerman T. & Sloof R. (2020). [On the effect of anchoring on valuations when the anchor is transparently uninformative](https://link.springer.com/article/10.1007/s40881-020-00094-1). *Journal of the Economic Science Association*

### Abstract

We test whether anchoring affects people’s elicited valuations for a bottle of wine in individual decision-making and in markets. We anchor subjects by asking them if they are willing to sell a bottle of wine for a transparently uninformative random price. We elicit subjects’ Willingness-To-Accept for the bottle before and after the market. Subjects participate in a double auction market either in a small or a large trading group. The variance in subjects’ Willingness-To-Accept shrinks within trading groups. Our evidence supports the idea that markets have the potential to diminish anchoring effects. However, the market is not needed: our anchoring manipulation failed in a large sample. In a concise meta-analysis, we identify the circumstances under which anchoring effects of preferences can be expected. 

### Software

The analysis was conducted using ```Stata 16```.

### Files

The files are stored in two folders: Data, which contains data from the experiment and the meta analysis, and Stata, which contains the Stata code to produce every result in the paper.

1. Data
   * Experimental Data.csv (*The raw data from the experiment in csv format*)
   * Experimental Codebook.md (*Codebook for ```Experimental Data.csv```*)
   * Meta Data.csv (*The raw data for the meta analysis in csv format*)
   * Meta Codebook.md (*Codebook for ```Meta Data.csv```*)
2. Stata
   * Data Analysis.do (*Calls and executes all other files*)
   * Prepare Raw Data.do (*Cleans raw experimental data and prepares it for analysis*)
   * Main Effect.do (*Produces the main result of Subsection 3.1, Table 1 and Figure 1*)
   * Robustness.do (*Produces the robustness checks from the end of Subsection 3.1*)
   * Direction.do (*Produces results of Subsection 3.2 and Figure 2*)
   * Magnitude.do (*Produces Table 2*)
   * Power Analysis (*Produces results for first paragraph of Section 4*)
   * Prepare Raw Data.do (*Cleans raw meta data and prepares it for analysis*)
   * Meta Analysis.do (*Produces Table 3 and Figure 3*)

### Instructions
To run the code, you only need to run **Data Analysis.do**.

## Contributing

**[Konstantinos Ioannidis](http://konstantinosioannidis.com/)** 
For any questions, please email me here **ioannidis.a.konstantinos@gmail.com**.
