FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["commander-graphql.csproj", "./"]
RUN dotnet restore "commander-graphql.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "commander-graphql.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "commander-graphql.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "commander-graphql.dll"]
