# Lucas Square Pyramid
## Project 94:
### Team Members
Mohan Kalyan Veeraghanta
Bala Surya Krishna Vankayala

### Work Size Unit:
The ideal work unit size for our implementation is set to 1000 when the value of 𝑛 is less than or equal to 1000. 
For cases where 𝑛 exceeds 1000, the optimal unit size is determined by using the square root of 𝑛 for each sub-task. 
This configuration was established through extensive experimentation, where we tested a range of values for both large and small 𝑛 to find the most efficient approach.

### Results for Input: 
Upon executing the program with 
𝑛 = 1000000 and k = 4 workers, output was not produced.

### Performance Metrics:
We assessed the program's performance by running the following commands:

Windows (Powershell): .\time.ps1 -ProgramPath ".\lukas.exe" -Arguments "1000000 4"
The recorded times were as follows:

User Time:    0.21875 seconds
System Time:  0 seconds
CPU Time:     0.21875 seconds (user + sys)
Real Time:    0.0847409 seconds


Cores used:   2.58139812062416 (CPU time to real-time ratio)

### Largest Problem that we could solve is
Inputs: n = 1000000000 k = 2
approximately we can define the number of worker as sqrt(1000000000) approx. 31622.78
This shows the efficiency and scalability of our pony-based parallel implementation.
