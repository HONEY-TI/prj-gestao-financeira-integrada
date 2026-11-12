using Application.Dtos;
using Application.Dtos.Profile;
using AutoMapper;
using Microsoft.Extensions.Logging.Abstractions;
using xUnit.Test.__mock__.Entities;

namespace xUnit.Test.Application.Dtos;
public sealed class ReceitaDtoTest
{

    [Fact]
    public void ReceitaDto_Should_Set_Properties_Correctly()
    {
        // Arrange
        var mapper = new Mapper(new MapperConfiguration(cfg => {
            cfg.AddProfile<ReceitaProfile>();
        }, NullLoggerFactory.Instance));

        // Act
        var receita = ReceitaFaker.Instance.Receitas().First();
        var receitaDto = mapper.Map<ReceitaDto>(receita); 

        // Assert
        Assert.Equal(receita.Id, receitaDto.Id);
        Assert.Equal(receita.Data, receitaDto.Data);
        Assert.Equal(receita.Descricao, receitaDto.Descricao);
        Assert.Equal(receita.Valor, receitaDto.Valor);
        Assert.Equal(receita.UsuarioId, receitaDto.UsuarioId);
        Assert.Equal(receita?.Categoria?.Id, receitaDto.IdCategoria);
    }
}