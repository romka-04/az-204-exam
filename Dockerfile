FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["az-204-exam.csproj", "./"]
RUN dotnet restore "az-204-exam.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "az-204-exam.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "az-204-exam.csproj" -c Release -o /app/publish

FROM nginx:alpine AS final
WORKDIR /user/share/nginx/html
COPY --from=publish /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
