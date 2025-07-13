using API.MarginSKU.Application.Interfaces;
using API.MarginSKU.Domain.Entities;
using API.MarginSKU.Infrastructure.Interfaces;


namespace API.MarginSKU.Application.Services
{
    public class CustomerService : ICustomerService
    {
        private readonly ICustomerRepository _customerRepository;

        public CustomerService(ICustomerRepository customerRepository)
        {
            _customerRepository = customerRepository;
        }

        public async Task<IEnumerable<Customer>> GetAllAsync()
        {
            return await _customerRepository.GetAllAsync();
        }

    }
}
