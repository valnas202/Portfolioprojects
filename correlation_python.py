# import libraries
from statistics import correlation

import pandas as pd
import seaborn as sns
import numpy as np

import matplotlib
import matplotlib.pyplot as plt
from jedi.api.refactoring import inline

plt.style.use('ggplot')
from matplotlib.pyplot import figure

matplotlib.rcParams['figure.figsize'] = (12,8) # Adjusts the configuration of the plots we will create

# Read the CSV file
df= pd.read_csv(r"C:\Users\Administrator\OneDrive\Documents\movies.csv")
print(df.head())

# Lets see if there is any missing data
for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))

# drop the rows that have missing data
df = df.dropna()
print(df)

# Data types for our columns
print(df.dtypes)

#Change data type of columns
df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')
print(df)

# Create correct year column
df['yearcorrect'] = df['released'].str.extract(pat = '([0-9]{4})').astype(int)
print(df)

df = df.sort_values(by=['gross'], inplace=False, ascending=False)
print(df)

pd.set_option('display.max_rows', None)
print(df)

# Drop any duplicates
df['company'].drop_duplicates().sort_values(ascending=False)

# Scatter plot with budget vs gross
plt.scatter(x=df['budget'],y=df['gross'])
plt.title('Budget vs Gross Earnings')
plt.xlabel('Gross Earnings')
plt.ylabel('Budget for Film')
plt.show()

df.head()
print(df)

# plot the budget vs gross using seaborn
sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color": "red"}, line_kws={"color":"blue"})


# Let's start lookiung at correlation
df = df.corr(numeric_only="True")
print(df)

# High correlation between budget and gross
correlation_matrix = df.corr(method='pearson')
sns.heatmap(correlation_matrix, annot=True)
plt.title('Correlation Matrix for Numeric features')
plt.xlabel('Movie features')
plt.ylabel('Movie features')
plt.show()

# Look at company
df_numerized = df
for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name] = df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
df_numerized
print(df_numerized)

correlation_matrix = df_numerized.corr(method='pearson')
sns.heatmap(correlation_matrix, annot=True)
plt.title('Correlation Matrix for Numeric features')
plt.xlabel('Movie features')
plt.ylabel('Movie features')
plt.show()

correlation_matrix=df_numerized.corr()
corr_pairs = correlation_mat.unstack()
print(corr_pairs)

sorted_pairs = corr_pairs.sort_values()
print(sorted_pairs)

high_corr = sorted_pairs[(sorted_pairs) > 0.5]
print(high_corr)

# Votes and budget have the highest correlation to gross earnings



