
using API.MarginSKU.Application.Interfaces;
using API.MarginSKU.Application.Services;
using API.MarginSKU.Infrastructure.Data;
using API.MarginSKU.Infrastructure.Data.Repositories;
using API.MarginSKU.Infrastructure.Interfaces;

namespace API.MarginSKU
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            builder.Services.AddScoped<DapperContext>();
            
            builder.Services.AddScoped<IGoodRepository, GoodRepository>();
            builder.Services.AddScoped<IGoodService, GoodService>();

            builder.Services.AddScoped<ICustomerRepository, CustomerRepository>();
            builder.Services.AddScoped<ICustomerService, CustomerService>();

            builder.Services.AddScoped<IProjectRepository, ProjectRepository>();
            builder.Services.AddScoped<IProjectService, ProjectService>();

            builder.Services.AddScoped<IMarginRepository, MarginRepository>();
            builder.Services.AddScoped<IMarginService, MarginService>();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
