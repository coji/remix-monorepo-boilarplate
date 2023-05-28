import { json, type LoaderArgs, type V2_MetaFunction } from '@remix-run/node'
import { useLoaderData } from '@remix-run/react'
import { PrismaClient } from 'database'
import { Button } from 'ui'

const client = new PrismaClient()
export const meta: V2_MetaFunction = () => {
  return [{ title: 'New Remix App' }, { name: 'description', content: 'Welcome to Remix!' }]
}

export const loader = async ({ request }: LoaderArgs) => {
  const users = await client.user.findMany({
    select: {
      id: true,
      name: true,
      email: true,
    },
  })
  return json({ users })
}

export default function Index() {
  const { users } = useLoaderData<typeof loader>()

  return (
    <div style={{ fontFamily: 'system-ui, sans-serif', lineHeight: '1.8' }}>
      <h1>Web</h1>
      {users.map((user) => {
        return (
          <div key={user.id}>
            {user.name} {user.email}
          </div>
        )
      })}
      <Button />
    </div>
  )
}
