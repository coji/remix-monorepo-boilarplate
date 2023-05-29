import { PrismaClient } from '@prisma/client'

let prisma: PrismaClient

declare global {
  var __db__: PrismaClient
}

if (process.env.NODE_ENV === 'production' || process.env.NODE_ENV === 'test') {
  prisma = new PrismaClient()
} else {
  if (!global.__db__) {
    const prisma = new PrismaClient({ log: [{ emit: 'event', level: 'query' }] })
    prisma.$on('query', (e) => {
      console.log(`${e.query} ${e.params}`)
    })
    global.__db__ = prisma
  }
  prisma = global.__db__
  void prisma.$connect()
}

export { prisma }
