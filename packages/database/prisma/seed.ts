import { PrismaClient } from '@prisma/client'

const seed = async () => {
  const prisma = new PrismaClient()
  await prisma.user.deleteMany()
  await prisma.user.create({
    data: {
      name: 'Alice',
      email: 'alice@example.com',
      password: 'alice123',
    },
  })
}

void seed()
