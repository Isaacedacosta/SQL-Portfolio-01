-- Essa é uma compilação de diversos scripts que vão sendo utilizado para filtrar e analisar os dados coletados dentro do site www.ourworldindata.org
-- É necessário que o script desejado seja selecionado para execução (ou que se "coment out" os scripts que a parte desejada) para evitar que o programa gere todas as tabelas criadas

-- Acessar toda a tabela CovidDeaths e ordenar pelas colunas 3 e 5 (confirmar que os dados estão devidamente carregados no BD)
Select *
From PortfolioProject..CovidDeaths
Order by 3, 5 desc

-- Lista de paises que estao presentes nos dados
Select location
From PortfolioProject..CovidDeaths
Group by location
Order by location


-- Acessar toda a tabela CovidVaccinations e ordenar pelas colunas 3 e 4 (confirmar que os dados estão devidamente carregados no BD)
Select *
From PortfolioProject..CovidVaccinations
Order by 3, 4

-- Selecionando os dados que serão utilizados para analise na tabela CovidDeaths
Select Location, Population, Date, Total_cases, New_cases, Total_deaths
From PortfolioProject.dbo.CovidDeaths
Order by 1, 3

-- Checando Mortalidade percentual (Total de mortes por Total de casos), evolucao por data
-- Na hora de manipular os dados surgiu o erro informando que os dados estavam com o tipo NVARCHAR e que esse tipo de dado é invalido para divisão portanto foi utilizada a operação "cast as"
-- O SSMS recusou a conversão para int, aceitou para float mas encontrou problemas de exibicao para operações com resultados muito pequenos, porem funcionou perfeitamente em decimal
-- Foi introduzido porém comentado para fora do codigo a operação de filtro por localização para eventuais consultas por país.
Select Location, Population, Date, Total_cases, Total_deaths, (cast(Total_deaths as decimal)/cast(Total_cases as decimal))*100 as Deaths_Percentual
From PortfolioProject.dbo.CovidDeaths
--Where location like 'Brazil'
Order by 1, 3


-- Checando Taxa percentual de infeccao populacional (Total de casos por Populacao total) evolucao por data
-- Ao inves de "cast as" foi utilizado o comando convert para a mesma operãcao apenas por exemplo
Select Location, Population, Date, Total_cases, (convert(decimal, Total_cases)/convert(decimal, Population))*100 as Percentual_Infeccao 
From PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
Order by 1, 3


-- Checando Taxa percentual de infeccao populacional total (ate o ultimo registro) agrupando por pais
-- Filtrando do maior indice de infeccao para o menor
-- Foi preciso converter a coluna Total_cases em decimal antes de manipular para encontrar o maior valor e tambem no momento da divisao para encontrar o percentual de infeccao, estava apresentando valores errados antes disso
-- Foi adicionado o filtro "Where continent is not null" pois a tabela tras o valor acumulado por continente e classifica esse dado como localizacao deixando o campo continente como null
-- a remocao dessa forma foi mais facil do que declarar todos os continentes para nao aparecerem como localizacao
Select Location, Population, Max(convert(decimal, Total_cases)) as Total_casos_atualizado, Max(convert(decimal, Total_cases))/population*100 as Percentual_Infeccao
From PortfolioProject.dbo.CovidDeaths
Where Continent is not null
Group by Location, Population
Order by Percentual_Infeccao desc --asc (para lista crescente)